Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3AOERh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:17:37 -0500
Received: from nm18.access.bullet.mail.sp2.yahoo.com ([98.139.44.145]:34228
	"EHLO nm18.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204Ab3AOERd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:17:33 -0500
X-Yahoo-Newman-Id: 33075.12219.bm@smtp108.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JoyvjDgVM1kqYglzBZ4NkQucdh5PEyW3boBg9mBV.qASIVS
 ypCKJIkSwAyBu8VMO1_eNlLlLBB_0pPNPLlBqiBi4_8EA9_g5dw_CMvDuLEf
 ILv_VfEG.Hgf9Fh99VP20hI7HcqU9Xs9pynR32aiQNOIPaahdrZQ5v7DJTr1
 2JIgqCzxDAjyBr047SUN..VuYFDb6dI0j_D97X5eEZfrNwtLmKpHq2FoQ5YX
 Y1GZ3QQTjboJU.G5DAMZbSboPLDojI9UXXJfg0BtntCWCRvzUQ_H_LmpO1RZ
 jy2EjH9AMKAYt9hTT2YsEHX8YkaxAQtwriBgncm4TKjxvC2Tj9Jyxz0H69bG
 6rkPAu7QoTgzChaQzGM4wcVMmNUfvQ0DWOejQyT50NsUnkYIRqxRalVoxZc3
 ApS1i0CDrCYku2HAlPzNZ0hL2ZXBYi86cd.9Xf80yltwCXA5tPCOEkfBvg_c
 RELlgpDE5BH2oUL1vEbgVDJ8-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50F4D83E.9050802@schaufler-ca.com>
Date: Mon, 14 Jan 2013 20:17:02 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <50EC5BCD.9000908@tycho.nsa.gov>
In-Reply-To: <50EC5BCD.9000908@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2013 9:47 AM, Stephen Smalley wrote:
> On 01/07/2013 08:54 PM, Casey Schaufler wrote:
>> Subject: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
>>
>> Change the infrastructure for Linux Security Modules (LSM)s
>> from a single vector of hook handlers to a list based method
>> for handling multiple concurrent modules.
>>
>> A level of indirection has been introduced in the handling of
>> security blobs. LSMs no longer access ->security fields directly,
>> instead they use an abstraction provided by lsm_[gs]et field
>> functions.
>>
>> The XFRM hooks are only used by SELinux and it is not clear
>> that they can be shared. The First LSM that registers using
>> those hooks gets to use them. Any subsequent LSM that uses
>> those hooks is denied registration.
>>
>> Secids have not been made shareable. Only one LSM that uses
>> secids (SELinux and Smack) can be used at a time. The first
>> to register wins.
>>
>> The "security=" boot option takes a comma separated list of
>> LSMs, registering them in the order presented. The LSM hooks
>> will be executed in the order registered. Hooks that return
>> errors are not short circuited. All hooks are called even
>> if one of the LSM hooks fails. The result returned will be
>> that of the last LSM hook that failed.
>>
>> Some hooks don't fit that model. setprocattr, getprocattr,
>> and a few others are special cased. All behavior from
>> security/capability.c has been moved into the hook handling.
>> The security/commoncap functions used to get called from
>> the LSM specific code. The handling of the capability
>> functions has been moved out of the LSMs and into the
>> hook handling.
>>
>> The /proc/*/attr interfaces are given to one LSM. This
>> can be done by setting CONFIG_SECURITY_PRESENT. Additional
>> interfaces have been created in /proc/*/attr so that
>> each LSM has its own named interfaces.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>
> Have you run any benchmarks, particularly to compare performance
> overhead in the simple case of a single LSM?
>

Yes. Finally.


I ran a series of micro-benchmarks on the assumption that
we're most concerned with system call performance. I used
lmbench, not because it's the world's greatest benchmark
but because it targets some of the things I care about.
I am perfectly happy to accept suggestions of other benchmarks,
but I make no guarantees that I'll be able to run them.

I ran sets of three runs for each configuration and tossed
any benchmark where I had too great a deviation. I ran one
set on Fedora 17 and another on Ubuntu 12.04. I ran what I
consider some interesting configurations, with both the old
LSM infrastructure and the stacking infrastructure.

I compared the performance for these configurations:

	CONFIG_SECURITY disabled
	CONFIG_SECURITY enabled, no LSM specified
	CONFIG_SECURITY enabled, SELinux enabled
	CONFIG_SECURITY enabled, SELinux and Yama enabled
	CONFIG_SECURITY enabled, Smack enabled
	CONFIG_SECURITY enabled, Smack and Yama enabled

I also ran SELinux + AppArmor + Yama, Smack + AppArmor + Yama
and Smack + AppArmor + TOMOYO + Yama under the stacking
framework, but as I can't run them without it I can't do
comparisons.

I found that with security disabled I got 0.79% worse
overall performance with Fedora but a 0.81% better overall
performance with Ubuntu. The combined was 0.01% better,
so I figure that the methodology looks OK.

On Fedora I found that for all comparable configurations
stacking added 1.23%. For Ubuntu, it was 0.61%.

I am no statistician, and I do not aspire to becoming one. 
I know that my methods were nowhere near clean and were
in fact very noisy. I had to disqualify a good number of
my results because the deviation between runs was too large.


