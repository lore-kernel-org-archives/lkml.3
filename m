Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3KSNqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:46:40 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40269 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752354Ab3KSNqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:46:38 -0500
Message-ID: <528B6BB3.7020303@hurleysoftware.com>
Date: Tue, 19 Nov 2013 08:46:27 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heorhi Valakhanovich <valahanovich@tut.by>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] tty: Only hangup once
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com>	<20131117203850.46df2124@tormoz-pc>	<20131118134211.17861db3@alan.etchedpixels.co.uk>	<528A5043.6030901@hurleysoftware.com>	<528A797B.6020807@hurleysoftware.com> <20131119000923.5ca40e51@tormoz-pc>
In-Reply-To: <20131119000923.5ca40e51@tormoz-pc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 04:09 PM, Heorhi Valakhanovich wrote:
> On Mon, 18 Nov 2013 15:32:59 -0500
> Peter Hurley <peter@hurleysoftware.com> wrote:
>
>> On 11/18/2013 12:37 PM, Peter Hurley wrote:
>>> On 11/18/2013 08:42 AM, One Thousand Gnomes wrote:
>>>>> After upgrading to kernel 3.12 I noticed one issue with tmux
>>>>> software. The easiest way to reproduce will be:
>>>>> 1. Start tmux session as root.
>>>>> 2. Connect via ssh and use "tmux attach" to attach to the running
>>>>> session.
>>>>> 3. Kill ssh client.
>>>
>>> Heorhi,
>>>
>>> Thanks for the report.
>>>
>>>>> You can notice that shell (zsh in my case) and "tmux attach" are
>>>>> still remains in process' list. That didn't happen in previous
>>>>> kernels.
>>
>> Heorhi,
>>
>> I could not reproduce this behavior with zsh or bash.
>>
>> In case I misunderstood, the steps I took to reproduce were,
>>
>> [On ssh server machine running 3.12]
>> 1.  Add 'set-option -g default-shell /usr/bin/zsh' to /etc/tmux.conf
>
> This is really not necessary. I also reproduced it with bash.
>
>> 2a. In terminal window, 'sudo tmux'
>>         - also tried -
>> 2b. At root login on tty2, 'tmux'
>>
>> Successfully starts tmux session. Then,
>>
>> [On ssh client machine]
>> 1. 'ssh user@server'
>> 2. 'sudo tmux attach'
>> 3. Switch to 2nd terminal window,
>> 4. ps -ef | grep ssh
>> 5. kill $pid_from_step4
>>
>> This *did not* leave the 'tmux attach' process alive.
>>
>> Is zsh your login shell as well? Maybe that's the required
>> component to reproduce the behavior you've observed.
>>
>> Regards,
>> Peter Hurley
>
> Thank you for your attention.
> I tried to reproduce it exactly as you did and notice strange thing.
> You use "sudo tmux attach" and tmux client uses the terminal created
> for regular user and those works good.
>
> But if you will use "ssh root@server" (you can use localhost too) the
> "tmux attach" will use terminal created from root (i checked this with
> lsof and ls -al /dev/pts) and behavior is different. Are terminals
> created for root is somehow different from those created for regular
> users?
>
> If you can't use root ssh login I will try to reproduce it's for sudo by
> mixing some kind of dtach and tmux but it will be very unclear at the
> end.

Thanks for the additional testing; yes, the "ssh root@server" is the
crucial difference. I was able to reproduce the problem immediately.

Before sshd execs a new root shell, it hangs up and then re-opens
the current tty as a security measure. Because the tty state was not
being reset, the subsequent re-open could not be hung up.

Would you please test the patch below and confirm the fix?

--->%---
Subject: [PATCH] tty: Reset hupped state on open

A common security idiom is to hangup the current tty (via vhangup())
after forking but before execing a root shell. This hangs up any
existing opens which other processes may have and ensures subsequent
opens have the necessary permissions to open the root shell tty/pty.

Reset the TTY_HUPPED state after the driver has successfully
returned the opened tty (perform the reset while the tty is locked
to avoid racing with concurrent hangups).

Reported-by: Heorhi Valakhanovich <valahanovich@tut.by>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
  drivers/tty/tty_io.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3a1a01a..c74a00a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2086,6 +2086,7 @@ retry_open:
  			filp->f_op = &tty_fops;
  		goto retry_open;
  	}
+	clear_bit(TTY_HUPPED, &tty->flags);
  	tty_unlock(tty);


-- 
1.8.1.2


