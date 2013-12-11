Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3LKXi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:38:56 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54762 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3LKXix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:38:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAA9_cme4XmXqQfx9kTPEJWdx2XwBZk-G8s7pjSuZ5KWg3UZZ8Q@mail.gmail.com>
References: <CAGm_ybgC6Ca0qz6zJL0PkEUiyUi=Ct0L5t2GJOt9ZU-buP+wBQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1312111204220.1531-100000@iolanthe.rowland.org>
	<CAODwPW_ZUgHWymOF7Fzxh7sbhrvV0-g-pMXWQm=eSz2U8EBRtQ@mail.gmail.com>
	<20131211193647.GA25483@xanatos>
	<CAA9_cme4XmXqQfx9kTPEJWdx2XwBZk-G8s7pjSuZ5KWg3UZZ8Q@mail.gmail.com>
Date: Wed, 11 Dec 2013 15:38:52 -0800
X-Google-Sender-Auth: P8EHBiDMcjqwPPqo5ryFC4E46a0
Message-ID: <CAA9_cmc8b2rmp6hsgkLUEnFBmKqwdYCbdb_2rEycs-qVksAFpg@mail.gmail.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed HUBs
From: Dan Williams <dan.j.williams@intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Vikas Sajjan <sajjan.linux@gmail.com>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Douglas Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 2:51 PM, Dan Williams <dan.j.williams@gmail.com> wrote:
> On Wed, Dec 11, 2013 at 11:36 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
>> On Wed, Dec 11, 2013 at 11:00:13AM -0800, Julius Werner wrote:
>>> > I don't know what you mean by "fails".  The system goes to sleep and
>>> > then later on wakes up, doesn't it?
>>> >
>>> > Do you mean that the Jetflash device gets disconnected when the system
>>> > wakes up?  That's _supposed_ to happen under those circumstances.
>>> > When hub_activate() sees HUB_RESET_RESUME, all child devices get
>>> > disconnected except those where udev->persist_enabled is set.
>>>
>>> This patch was written in response to the same bug as my "usb: hub:
>>> Use correct reset for wedged USB3 devices that are NOTATTACHED"
>>> submission. My patch only helps when the port gets stuck in Compliance
>>> Mode, but Vikas reports that he can sometimes see it stuck in Polling
>>> or Recovery states as well.
>>>
>>> The underlying issue is a deadlock in the USB 3.0 link training state
>>> machine when the host controller is unilaterally reset on resume
>>> (without driving a reset on the bus).
>>
>> The xHCI spec requires that when the xHCI host is reset, a USB reset is
>> driven down the USB 3.0 ports.  If hot reset fails, the port may migrate
>> to warm reset.  See table 32 in the xHCI spec, in the definition of
>> HCRST.  It sounds like this host doesn't drive a USB reset down USB 3.0
>> ports at all on host controller reset?
>
> ...although, the spec says that it does not wait for the port resets
> to complete.  As far as I can see re-issuing a warm reset and waiting
> is the only way to guarantee the core times the recovery.  Presumably
> the portstatus debounce in hub_activate() mitigates this, but that
> 100ms is less than a full reset timeout.  I have something similar in
> the port power rework patches [1], but I think something like the
> following (untested) is more generic, it arranges for reset_resume to
> start with a warm reset if necessary.
>
> (also attached)
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index a7c04e24ca48..30ce237569dd 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -2783,8 +2783,14 @@ static int check_port_resume_type(struct
> usb_device *udev,
>                 struct usb_hub *hub, int port1,
>                 int status, unsigned portchange, unsigned portstatus)
>  {
> +       /* Did the port go SS.Inactive?  Even if ->persist_enabled is
> cleared the
> +        * device won't come back until a warm reset completes
> +        */
> +       if (hub_port_warm_reset_required(hub, portstatus)) {
> +               udev->reset_resume = 1;
> +               udev->reset_resume_warm = 1;

Also need to set 'status' to 0 here.

If it's truly just a case of waiting for port warm resets to complete
it might be better to inject additional debounce delay here, but the
spec seems to indicate that there is no way to know that escalated
warm resets are in progress.  4.19.5.1 says "The Port Reset (PR) flag
shall be ‘1’ while Hot or Warm Reset is being executed. The Port Reset
Change (PRC) flag shall be set (‘1’) when the reset execution is
complete and PR transitions to ‘0’."... but that is only if software
initiated the warm reset.  When the warm reset was the result of an
HCRST we hit "Note, the completion of the xHC reset process is not
gated by the Root Hub port reset process."
