Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab3FRP4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:56:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3FRP4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:56:53 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rLUhBioUM6kA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-Z3wEZ91IRQA:10 a=9pinBZ9FrmrZdufnmFcA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371571012.18733.33.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] sched,misc: Use schedule_(raw_)spin_unlock and
 schedule_(raw_)spin_unlock_irq
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Date: Tue, 18 Jun 2013 11:56:52 -0400
In-Reply-To: <1451381371569817@web21d.yandex.ru>
References: <1451381371569817@web21d.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 19:36 +0400, Kirill Tkhai wrote:
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index f487a47..f0ab843 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -474,10 +474,9 @@ do
> {                                                                       \
>                         break;                                          \
>                 }                                                       \
>                 if
> (irq)                                                \
> -                       spin_unlock_irq(&(wq).lock);                    \
> +                       schedule_spin_unlock_irq(&(wq).lock);           \
>                 else                                                    \
> -                       spin_unlock(&(wq).lock);                        \
> -               schedule();                                             \
> +                       schedule_spin_unlock(&(wq).lock);               \
>                 if
> (irq)                                                \
>                         spin_lock_irq(&(wq).lock);                      \
>                 else                                                 


In this part, I would clean it up as:

	if (irq) {
		schedule_spin_unlock_irq(&(wq).lock)
		spin_lock_irq(&(wq).lock);
	} else {
		schedule_spin_unlock(&(wq).lock);
		spin_lock(&(wq).lock);
	}

The old way just had a single call to schedule. The new way has two
different calls to schedule via the helper functions. No need to have
two if statements for that.

-- Steve


