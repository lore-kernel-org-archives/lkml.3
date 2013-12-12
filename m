Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3LLSMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:12:03 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:65381 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LLSMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:12:00 -0500
MIME-Version: 1.0
In-Reply-To: <20131212145458.GB31540@redhat.com>
References: <20131211235427.GA23999@www.outflux.net>
	<20131212145458.GB31540@redhat.com>
Date: Thu, 12 Dec 2013 10:11:59 -0800
X-Google-Sender-Auth: xh8dpUqJwpFYE0mcHvrdk0S3hjw
Message-ID: <CAGXu5jLWOVWX5KKjpEcDaApJzfPsQJffsiJuy7VvPnaLFvzGYw@mail.gmail.com>
Subject: Re: [PATCH v3] kexec: add sysctl to disable kexec_load
From: Kees Cook <keescook@chromium.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biederman <ebiederm@xmission.com>, Rik van Riel <riel@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Rob Landley <rob@landley.net>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 6:54 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Dec 11, 2013 at 03:54:27PM -0800, Kees Cook wrote:
>> For general-purpose (i.e. distro) kernel builds it makes sense to build with
>> CONFIG_KEXEC to allow end users to choose what kind of things they want to do
>> with kexec. However, in the face of trying to lock down a system with such
>> a kernel, there needs to be a way to disable kexec_load (much like module
>> loading can be disabled). Without this, it is too easy for the root user to
>> modify kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are
>> set. With this change, it is still possible to load an image for use later,
>> then disable kexec_load so the image (or lack of image) can't be altered.
>>
>
> Hi Kees,
>
> I am still not able to wrap my head around that how it will be used in
> practice.
>
> So you seem to be planning that user space will load a kdump kernel early
> and then disable further load of any kexec/kdump images.

Right -- I was hoping to make this available to systems beyond those
that just want all of kexec disabled. It seemed like a trivial change
-- being able to disable loading means locking in the state of
loading, which is exactly what modules_disabled does now: the system
can load all the modules it wants first, and then lock down further
changes. There doesn't seem to be a good reason to disable ALL of
kexec when just disabling loading is sufficient.

> We are doing all this to protect against root loading a image we don't
> want and it is root who will load an image to begin with. Your argument
> is that if root changes the init scripts, then those changes will take
> affect only during next reboot and will be detected.
>
> I don't understand that how would you enforce it. What if root changes it
> and just waits for next scheduled maintenance reboot. So this does not
> sound very convincing to me. If there was a way to disable kexec
> completely using command line, then I could understand that in some
> cases hypervisor will control how virtual machines are launched with
> hypervisor determined command line paramaters and hypervisor could
> enforce that kexec/kdump are disabled and root in virtual machine can't
> do anything about it.

I'm not claiming "perfect" security here. What I'm doing is changing
the window of exposure. If an attacker has to wait until the next
scheduled reboot, there is now a larger window of time for the actual
root user to notice problems (e.g. filesystem change checkers like
tripwire, external logging monitors seeing suspicious things), etc.
This doesn't make it impossible for an attacker to win, but it makes
it impossible for an attacker to win (via kexec) immediately and
silently. This raises the bar for a successful attack. No longer is it
possible to have a drive-by rootkitting -- now a system must be
studied, an attack must be specialized and planned, etc.

> But we seem to be first trusting root to disable kexec/kdump and then
> little later not trusting same root and expecting that if that root
> changes something it will take affect only after a reboot and we will
> notice it. I am not convinced about the *noticing a reboot* part.
>
> So while patch is simple and seems to be making sense, what's the
> exact use case and how it will be enforced is still unclear to me.

The intention is for using this in environments where "perfect"
enforcement is hard. Without a verified boot with verified modules and
kexec, this is trying to give a system a better chance to defend
itself against attack in the face of a privilege escalation.

In my mind, I consider several scenarios:

1) verified boot of read-only verified root fs loading fd-based
verification of kexec images
2) secure boot of writable root fs loading signed kexec images
3) regular boot loading kexec image early and locking it
4) regular boot with no control of kexec image at all

1 and 2 don't exist yet, but will soon once the verified kexec series
has landed. 4 is the state of things now. The gap between 2 and 4 is
too large, so this change creates scenario 3, a middle-ground above 4
when 2 and 1 are not possible for a system.

-Kees

>
> Thanks
> Vivek
>
>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Acked-by: Rik van Riel <riel@redhat.com>
>> ---
>> v3:
>>  - renamed and clarified to kexec_load_disabled; Eric W. Biederman
>> v2:
>>  - updated sysctl documentation; akpm
>> ---
>>  Documentation/sysctl/kernel.txt |   15 ++++++++++++++-
>>  include/linux/kexec.h           |    1 +
>>  kernel/kexec.c                  |    3 ++-
>>  kernel/sysctl.c                 |   13 +++++++++++++
>>  4 files changed, 30 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
>> index 26b7ee491df8..3e1846427eda 100644
>> --- a/Documentation/sysctl/kernel.txt
>> +++ b/Documentation/sysctl/kernel.txt
>> @@ -33,6 +33,7 @@ show up in /proc/sys/kernel:
>>  - domainname
>>  - hostname
>>  - hotplug
>> +- kexec_load_disabled
>>  - kptr_restrict
>>  - kstack_depth_to_print       [ X86 only ]
>>  - l2cr                        [ PPC only ]
>> @@ -287,6 +288,18 @@ Default value is "/sbin/hotplug".
>>
>>  ==============================================================
>>
>> +kexec_load_disabled:
>> +
>> +A toggle indicating if the kexec_load syscall has been disabled. This
>> +value defaults to 0 (false: kexec_load enabled), but can be set to 1
>> +(true: kexec_load disabled). Once true, kexec can no longer be used, and
>> +the toggle cannot be set back to false. This allows a kexec image to be
>> +loaded before disabling the syscall, allowing a system to set up (and
>> +later use) an image without it being altered. Generally used together
>> +with the "modules_disabled" sysctl.
>> +
>> +==============================================================
>> +
>>  kptr_restrict:
>>
>>  This toggle indicates whether restrictions are placed on
>> @@ -331,7 +344,7 @@ A toggle value indicating if modules are allowed to be loaded
>>  in an otherwise modular kernel.  This toggle defaults to off
>>  (0), but can be set true (1).  Once true, modules can be
>>  neither loaded nor unloaded, and the toggle cannot be set back
>> -to false.
>> +to false.  Generally used with the "kexec_load_disabled" toggle.
>>
>>  ==============================================================
>>
>> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
>> index d78d28a733b1..a3e842f6867e 100644
>> --- a/include/linux/kexec.h
>> +++ b/include/linux/kexec.h
>> @@ -170,6 +170,7 @@ unsigned long paddr_vmcoreinfo_note(void);
>>
>>  extern struct kimage *kexec_image;
>>  extern struct kimage *kexec_crash_image;
>> +extern int kexec_load_disabled;
>>
>>  #ifndef kexec_flush_icache_page
>>  #define kexec_flush_icache_page(page)
>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>> index 490afc03627e..9405ae68feb4 100644
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -929,6 +929,7 @@ static int kimage_load_segment(struct kimage *image,
>>   */
>>  struct kimage *kexec_image;
>>  struct kimage *kexec_crash_image;
>> +int kexec_load_disabled;
>>
>>  static DEFINE_MUTEX(kexec_mutex);
>>
>> @@ -939,7 +940,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>>       int result;
>>
>>       /* We only trust the superuser with rebooting the system. */
>> -     if (!capable(CAP_SYS_BOOT))
>> +     if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
>>               return -EPERM;
>>
>>       /*
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index 34a604726d0b..ea4bb8152a34 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -62,6 +62,7 @@
>>  #include <linux/capability.h>
>>  #include <linux/binfmts.h>
>>  #include <linux/sched/sysctl.h>
>> +#include <linux/kexec.h>
>>
>>  #include <asm/uaccess.h>
>>  #include <asm/processor.h>
>> @@ -614,6 +615,18 @@ static struct ctl_table kern_table[] = {
>>               .proc_handler   = proc_dointvec,
>>       },
>>  #endif
>> +#ifdef CONFIG_KEXEC
>> +     {
>> +             .procname       = "kexec_load_disabled",
>> +             .data           = &kexec_load_disabled,
>> +             .maxlen         = sizeof(int),
>> +             .mode           = 0644,
>> +             /* only handle a transition from default "0" to "1" */
>> +             .proc_handler   = proc_dointvec_minmax,
>> +             .extra1         = &one,
>> +             .extra2         = &one,
>> +     },
>> +#endif
>>  #ifdef CONFIG_MODULES
>>       {
>>               .procname       = "modprobe",
>> --
>> 1.7.9.5
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
