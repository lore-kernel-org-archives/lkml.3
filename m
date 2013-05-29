Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966924Ab3E2Ugl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:36:41 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53561 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966776Ab3E2Ugd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:36:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130529180652.GJ32085@xanatos>
References: <1369445977-31404-1-git-send-email-jwerner@chromium.org>
	<20130529180652.GJ32085@xanatos>
Date: Wed, 29 May 2013 13:36:31 -0700
X-Google-Sender-Auth: hYpW38itnrYGyJfGVPA9PDq4eLA
Message-ID: <CAODwPW--sX5P6-m82iEt4+w=o_u7mHfJZpMLgoTb8niXPi_M_Q@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Use non-interruptible sleep for XHCI commands
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Frank_L=F6mker?= <Frank.Loemker@isa.de.com>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 11:06 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> I really wish you had contacted me about this issue before writing code
> to fix it.  Now I don't know the backstory behind this issue, which
> makes it hard to evaluate whether this fix is correct.

No worries... this was a very trivial patch and didn't take long. I
won't mind if we settle on a different solution here eventually (even
though I think this is the way that makes sense). The issue is very
easy to reproduce: just read of a UVC camera (I use Python with
"import cv2; dev = cv2.VideoCapture(0); dev.read()") and kill -9 the
process. However, you will have to pull in my other patch first ("usb:
xhci: Fix Command Ring Stopped Event handling"), or you may run into a
follow-up problem with cancelled commands that kills your whole HCD.

> On Fri, May 24, 2013 at 06:39:37PM -0700, Julius Werner wrote:
>> The XHCI stack usually uses wait_for_completion_interruptible_timeout()
>> to wait for the completion of an XHCI command, and treats both timeouts
>> and interruptions as errors. This is a bad idea, since these commands
>> are often essential for the correct operation of the USB stack, and
>> their failure can leave devices in a misconfigured and/or unusable
>> state.
>
> What causes the devices to be "unusable"?  If a Configure Endpoint
> command fails, the USB core is supposed to try to put the device back
> into its original state.  Is there a mismatch caused by the command
> being interrupted, and if so, how can we fix it, rather than allowing
> the kernel to go into an uninterruptible sleep?

The problem is that this happens while the USB core is already trying
to put the device back into its default/inactive state: the process
gets killed, its /dev/video0 file descriptor gets closed, the
uvc_v4l2_release() handler runs and eventually calls
usb_set_interface() to return the device to alternate setting 0 (back
from the "active" alternate setting that it was in while transmitting
video). But that alternate setting change requires an XHCI command,
which gets immediately cancelled because the SIGKILL signal keeps
lingering on the process until it is dead. (To be honest I am not
quite sure why the device stays unusable after that... I just get
bandwidth exceeded errors when I try to read it again from a new
process. Maybe there is another error in the bandwidth management code
there, but the problem remains that the UVC driver should be allowed
to correctly return the device to its default state even during a
SIGKILL.)

The other thing to note is that we already use uninterruptible sleeps
in many other places -- the USB core does it all the time: most
prominently in usb_start_wait_urb(), which is used for device
communication (SET_ADDRESS, SET_CONFIGURATION, etc.) during
enumeration (presumably to avoid similar problems as this patch). This
function is even used for the actual SET_INTERFACE message that is
sent to the device when changing alternate settings... so does it make
sense to make the (usually very fast and reliable, unless the hardware
is completely broken) communication with the xHC interruptible, when
for the same operation the much more unreliable communication with the
device is not?

>> This patch changes that behavior to use uninterruptible waits instead.
>> It fixes an easy to reproduce bug that occurs when you kill -9 a
>> process that reads from a UVC camera. The UVC driver's release code
>> tries to set the camera's alternate setting back to 0, but the lingering
>> SIGKILL instantly aborts any Stop Endpoint or Configure Endpoint command
>> sent to the xHC. The code dies halfway through the bandwidth allocation
>> process, leaving the device in an active configuration and preventing
>> future access to it due to the now out-of-sync bandwidth calculation.
>
> Obviously the command handling needs to be re-worked so this bandwidth
> mismatch doesn't happen.  What I would like to see instead (but have not
> had time to implement) is a global command queue manager.  It would have
> a queue of commands, similar to what we do for the TD lists, but only
> one list per xhci_hcd.  The command queue manager would handle
> cancellation requests, and properly keep track of whether each command
> completed.
>
> Functions submitting commands would all have a unique completion, and
> wait (interruptibly) on that completion.  Commands that are interrupted
> with a signal should attempt to cancel the command, and wait on the
> completion to see if their command was canceled or successfully
> completed.  If it was successfully completed, it should return success,
> rather than -ETIMEOUT.
>
> I think that change will fix the case where the bandwidth allocation
> gets out-of-sync with the USB core, but since you haven't shared the
> details of how the code handles being interrupted, I can't tell whether
> this is actually a good solution.

This sounds like a good idea in general, but I don't think it will fix
this problem. The issue is not that command cancellation doesn't work
(at least with my other patch, it does), it's just that the USB core
cannot do its job when every command gets cancelled immediately due to
a lingering signal. The only thing it can do when an add_endpoint() or
drop_endpoint() fails is to assume the device/slot is really hosed and
leave it in whatever state it is (and even if we solved the bandwidth
code so that it could recover from there later, I think leaving it
there in the first place is not good behavior). Therefore I think
cancelling commands (and thus failing those low-level operations) due
to something as trivial as a signal is not a good idea in general (and
the rest of the USB core seems to be implemented according to that
philosophy as well).
