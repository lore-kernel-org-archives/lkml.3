Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061Ab3E2Rke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:40:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934751Ab3E2Rk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:40:28 -0400
Date: Wed, 29 May 2013 19:36:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH] kernel/signal.c: avoid BUG_ON with SIG128 (MIPS)
Message-ID: <20130529173634.GA2020@redhat.com>
References: <1369846916-13202-1-git-send-email-james.hogan@imgtec.com> <51A638A4.2000705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A638A4.2000705@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29, David Daney wrote:
>
> On 05/29/2013 10:01 AM, James Hogan wrote:
>> MIPS has 128 signals, the highest of which has the number 128. The
>
> I wonder if we should change the ABI and reduce the number of signals to
> 127 instead of this patch.

Same thoughts...

>> @@ -2366,8 +2366,12 @@ relock:
>>
>>   		/*
>>   		 * Death signals, no core dump.
>> +		 *
>> +		 * MIPS has a signal number 128 which clashes with the core dump
>> +		 * bit. If this was the signal we still want to report a valid
>> +		 * exit code, so round it down to 127.
>>   		 */
>> -		do_group_exit(info->si_signo);
>> +		do_group_exit(min(info->si_signo, 127));

This avoids BUG_ON() but obviously fools WIFSIGNALED(), doesn't look
very nice.

Oleg.

