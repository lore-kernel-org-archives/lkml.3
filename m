Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaEZHQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:16:24 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59141 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEZHQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:16:22 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-e0-5382ea43f994
Message-ID: <5382EA43.5070607@hitachi.com>
Date: Mon, 26 May 2014 16:16:19 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>, Petr Mladek <pmladek@suse.cz>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Valdis.Kletnieks@vt.edu
Subject: Re: Re: [RFC PATCH 1/2] printk: Add context information to the
 header of /dev/kmsg
References: <20140519102835.30455.10437.stgit@yunodevel> <20140519102838.30455.86863.stgit@yunodevel> <CAPXgP11CpZH3b=joq=ic2ux5D4pcuncnWeiRSZ=p3V28LLbpTA@mail.gmail.com>
In-Reply-To: <CAPXgP11CpZH3b=joq=ic2ux5D4pcuncnWeiRSZ=p3V28LLbpTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

Thank you for your reply.

(2014/05/19 20:35), Kay Sievers wrote:
> On Mon, May 19, 2014 at 7:28 PM, Yoshihiro YUNOMAE
> <yoshihiro.yunomae.ez@hitachi.com> wrote:
>> Add context information to the header of /dev/kmsg.
>>
>> Two printk messages connected with KERN_CONT can be divided in multiple lines
>> by a different process context message. If the different context message seems
>> like the 1st divided message, it is difficult to understand which the 2nd
>> divided message belongs to. This problem can also occur for the situation where
>> multiple message lines without KERN_CONT are broken into by similar messages.
>> For example, SCSI disk error messages can be show as follows:
>>
>>          [110781.736171] sd 2:0:0:0: [sdb]
>>          [110781.736170] sd 3:0:0:0: [sdc] Unhandled sense code
>>          [110781.736172] sd 3:0:0:0: [sdc]
>>          [110781.736175] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>          [110781.736177] sd 3:0:0:0: [sdc]
>>          [110781.736178] Sense Key : Medium Error [current]
>>          [110781.736187] Sense Key : Recovered Error
>>          [110781.736189] [current]
>
> [...]
>
>> This patch adds PID and interrupt context flag to the header of /dev/kmsg as
>> the context information in order to understand relation of output messages. If
>> PID values of two messages and the interrupt context flags are same, it means
>> that those messages are same context, so those message have some relation. If
>> not so, it means that those messages are different context, so users do not
>> need to take care about the relation of the messages.
>
> [...]
>
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -197,6 +197,8 @@ enum log_flags {
>>
>>   struct printk_log {
>>          u64 ts_nsec;            /* timestamp in nanoseconds */
>> +       pid_t pid;              /* identify PID */
>> +       u32 irq_count;          /* identify irq_count */
>
> I don't think it is worth to blow-up this heavily used struct up even
> more, just because SCSI cannot log in simple single calls. How about
> fixing SCSI to log to a local buffer if it cannot safely print one
> line at once.
>
> I'm not convinced, that turning the /dev/kmsg format into an
> "annotation language', and requiring a rather complex state machine to
> re-construct the "broken" logging makes too much sense here. If tools
> rely on properly formatted logging messages, the logging should be
> fixed at the source while it is logged, not be reconstructed later.
>
> It is not not my call, but I don't this makes much sense. Continuation
> lines are "best effort" not a facility that is or ever was reliable in
> the past. I think the proper fix is how the log is created, not how it
> is exported.

As we discussed about this issue in LinuxCon Japan, mixed messages will
be fixed in each subsystem. In the SCSI layer, tracing feature will be
used. (http://www.spinics.net/lists/linux-scsi/msg74428.html)
If we found the same issue in other subsystem, we would like to add
new generic printk API to avoid mixed messages.

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


