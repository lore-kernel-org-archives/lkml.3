Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3FTHTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:19:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39376 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3FTHTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:19:07 -0400
X-Spam-Score: -100.8
Message-ID: <51C2ACB8.6050701@asianux.com>
Date: Thu, 20 Jun 2013 15:18:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/itimer.c: for return value, using -EINVAL instead
 of -EFAULT
References: <51C29FBC.1090507@asianux.com> <alpine.DEB.2.02.1306200847300.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306200847300.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 02:59 PM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, Chen Gang wrote:
> 
>> > For the system call getitimer(), if the parameter 'value' is NULL, need
>> > return -EINVAL, not -EFAULT.
> Care to explain why? Because you are feeling so?
> 

I am not feeling so, the original implementation really just checks the parameter 'value', if it is invalid, need return, is it incorrect ??


> I recommend reading the man page of getitimer:
> 
>  ERRORS
>        EFAULT new_value, old_value, or curr_value is not valid a pointer.
> 
> And NULL is definitely NOT a valid pointer.
> 
> The Posix spec does not specify an explicit error value for this
> syscall, but the general policy is:
> 
> [EFAULT]
>     Bad address. The system detected an invalid address in attempting
>     to use an argument of a call. The reliable detection of this error
>     cannot be guaranteed, and when not detected may result in the
>     generation of a signal, indicating an address violation, which is
>     sent to the process.
> 
> And we made use of this, which is correct and makes sense.
> 
> Returning EINVAL makes no sense at all, because EINVAL _IS_ a
> specified error code for this syscall:
> 
> [EINVAL]
>         The which argument is not recognized.

That means we need not check the parameter 'value' out side of copy_to_user().

And the implement need like this:

---------------------------diff begin-----------------------------------

diff --git a/kernel/itimer.c b/kernel/itimer.c
index 8d262b4..3b12271 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -102,15 +102,14 @@ int do_getitimer(int which, struct itimerval *value)
 
 SYSCALL_DEFINE2(getitimer, int, which, struct itimerval __user *, value)
 {
-	int error = -EFAULT;
+	int error;
 	struct itimerval get_buffer;
 
-	if (value) {
-		error = do_getitimer(which, &get_buffer);
-		if (!error &&
-		    copy_to_user(value, &get_buffer, sizeof(get_buffer)))
-			error = -EFAULT;
-	}
+	error = do_getitimer(which, &get_buffer);
+	if (!error &&
+	    copy_to_user(value, &get_buffer, sizeof(get_buffer)))
+		error = -EFAULT;
+
 	return error;
 }


---------------------------diff end-------------------------------------


Thanks.
-- 
Chen Gang

Asianux Corporation
