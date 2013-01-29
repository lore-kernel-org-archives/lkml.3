Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3A2UgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:36:15 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:57716 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3A2UgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:36:13 -0500
Message-ID: <5108329E.2050802@ahsoftware.de>
Date: Tue, 29 Jan 2013 21:35:42 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] fb: udlfb: fix hang at disconnect
References: <50F2A310.5010006@ahsoftware.de> <1359139768-32294-1-git-send-email-holler@ahsoftware.de> <1359139768-32294-2-git-send-email-holler@ahsoftware.de> <20130128162238.7fba92fe.akpm@linux-foundation.org> <51071E21.9030008@ahsoftware.de> <5107A5ED.7020009@ahsoftware.de> <5107AE4F.9000809@ahsoftware.de> <5107F014.4030704@ahsoftware.de>
In-Reply-To: <5107F014.4030704@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.01.2013 16:51, schrieb Alexander Holler:
> Am 29.01.2013 12:11, schrieb Alexander Holler:
>
>>
>> To explain the problem on shutdown a bit further, I think the following
>> happens (usb and driver are statically linked and started by the kernel):
>>
>> shutdown -> kill signal -> usb stack shuts down -> udlfb waits (forever)
>> for a kill or an urb which it doesn't get.
>
> Having a second look at what I've written above, I'm not even sure if
> the kernel sends one or more fatal signals on shutdown at all. I've just
> assumed it because otherwise down_interruptible() wouldn't have worked
> before (it would have stalled on shutdown too (if an urb got missed),
> not only on disconnect).
>
> Sounds like an interesting question I should read about (if/when fatal
> signals are issued by the kernel). ;)
>
>> Maybe the sequence is different if the usb-stack and udlfb are used as a
>> module and/or udlfb is used only for X/fb. I'm not sure what actually
>> does shut down the usb-stack in such a case, but maybe more than one
>> kill signal might be thrown around.

If anyone still follows my monologue: The question was interesting
enough that I couldn't resist for long. ;)

(all pasted => format broken)

In drivers/tty/sysrq.c there is

------
static void send_sig_all(int sig)
{
         struct task_struct *p;

         read_lock(&tasklist_lock);
         for_each_process(p) {
                 if (p->flags & PF_KTHREAD)
                         continue;
                 if (is_global_init(p))
                         continue;

                 do_send_sig_info(sig, SEND_SIG_FORCED, p, true);
         }
         read_unlock(&tasklist_lock);
}

static void sysrq_handle_term(int key)
{
         send_sig_all(SIGTERM);
         console_loglevel = 8;
}

(...)

static void sysrq_handle_kill(int key)
{
         send_sig_all(SIGKILL);
         console_loglevel = 8;
}
------

Now I've done some learning by doing (kernel 3.7.5 + some patches):

------
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index df249f3..db8a86c 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -1876,14 +1876,18 @@ static void dlfb_free_urb_list(struct dlfb_data
*dev)
         unsigned long flags;

         pr_notice("Freeing all render urbs\n");
+       if (current->flags & PF_KTHREAD)
+               pr_info("AHO: I'm a kernel thread\n");

         /* keep waiting and freeing, until we've got 'em all */
         while (count--) {

                 /* Timeout likely occurs at disconnect (resulting in a
leak) */
                 ret = down_timeout_killable(&dev->urbs.limit_sem,
FREE_URB_TIMEOUT);
-               if (ret)
+               if (ret) {
+                       pr_info("AHO: ret %d\n", ret);
                         break;
+               }

                 spin_lock_irqsave(&dev->urbs.lock, flags);
------

Now I've disconnected the display. And, as send_sig_all() already 
suggests, the result was (besides discovering an oops in 
call_timer_fn.isra (once)):

------
[  120.963010] udlfb: AHO: I'm a kernel thread
[  122.957024] udlfb: AHO: ret -62
------
(-62 is -ETIME)

So, if the above down_timeout_killable() is only down_interruptible(), 
as in kernel 3.7.5, the  box would not shutdown afterwards, because on 
shutdown no signal would be send to that kernel-thread which called 
dlfb_free_urb_list().

A last note: dlfb_usb_disconnect() (thus dlfb_free_urb_list()) isn't 
called on shutdown if the device would still be connected. So the 
problem only might happen, if the screen will be disconnected before 
shutdown (and an urb gets missed). So the subject of my patch is correct. ;)

</monologue>

Regards,

Alexander
