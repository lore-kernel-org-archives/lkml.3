Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaFMUpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:45:11 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:40422 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFMUpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <1402691813.27369.0.camel@buesod1.americas.hpqcorp.net>
References: <1402684097-5731-1-git-send-email-mcgrof@do-not-panic.com> <1402691813.27369.0.camel@buesod1.americas.hpqcorp.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 13 Jun 2014 13:44:47 -0700
X-Google-Sender-Auth: hUm9UkzamVzp141eiEWPcDWSe6E
Message-ID: <CAB=NE6VaVEUTDVmavvdKSJzq-2pKSd3ohwGZmSA61-65gVhKYQ@mail.gmail.com>
Subject: Re: [PATCH v3] printk: allow increasing the ring buffer depending on
 the number of CPUs
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: hpa@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Chris Metcalf <cmetcalf@tilera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 1:36 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Fri, 2014-06-13 at 11:28 -0700, Luis R. Rodriguez wrote:
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index 7228258..3f3356b 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -246,6 +246,7 @@ static u32 clear_idx;
>>  #define LOG_ALIGN __alignof__(struct printk_log)
>>  #endif
>>  #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
>> +#define __LOG_CPU_MIN_BUF_LEN (1 << CONFIG_LOG_CPU_MIN_BUF_SHIFT)
>>  static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>>  static char *log_buf = __log_buf;
>>  static u32 log_buf_len = __LOG_BUF_LEN;
>> @@ -752,6 +753,17 @@ void __init setup_log_buf(int early)
>>       unsigned long flags;
>>       char *new_log_buf;
>>       int free;
>> +     int cpu_extra = (num_possible_cpus() - 1) *  __LOG_CPU_MIN_BUF_LEN;
>
> I think you forgot to drop the - 1 here.

Actually that was on purpose as I had noticed in your suggestion on
the other thread to fix the minimum number of CPUs required for this
patch to be > 64 rather than >= 64 (with the defaults of 18 for log
shift, and 12 for min cpu log shift). Minor difference, but it was
intentional. Even though we do require SMP now the -1 can take effect,
and it seems safer for now to only require this for > 64 CPU
configurations for the defaults set. I'm happy to remove that as well,
but bumping the CPU configuration mark for this to > 64 might be
better for starters unless we do know for sure we also need this for
64.

  Luis
