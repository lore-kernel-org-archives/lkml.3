Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab3DAWVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:21:54 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43204 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809Ab3DAWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130401215834.GA5972@merkur.ravnborg.org>
References: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk>
	<1338230018-31052-2-git-send-email-vincent.sanders@collabora.co.uk>
	<20120528203005.GA20560@merkur.ravnborg.org>
	<20120529090614.GD12217@n2100.arm.linux.org.uk>
	<20120606101253.GM8262@n2100.arm.linux.org.uk>
	<87F2CC87-0FAF-49CB-AE70-423FB063A0E5@mvista.com>
	<20130401215834.GA5972@merkur.ravnborg.org>
Date: Mon, 1 Apr 2013 18:21:51 -0400
Message-ID: <CAE1uF8dCy3m3TO4xa6Cc3i-CM3QYUFADZH_6o+hgy6MSPEWnyQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Allow constructor name selection by architecture.
From: "George G. Davis" <gdavis@mvista.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Vincent Sanders <vincent.sanders@collabora.co.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Vincent Sanders <vince@collabora.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 5:58 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Apr 01, 2013 at 05:47:38PM -0400, George G. Davis wrote:
>> On Jun 6, 2012, at 6:12 AM, Russell King - ARM Linux wrote:
>> > On Tue, May 29, 2012 at 10:06:14AM +0100, Russell King - ARM Linux wrote:
>> >> On Mon, May 28, 2012 at 10:30:05PM +0200, Sam Ravnborg wrote:
>> >>> On Mon, May 28, 2012 at 07:33:37PM +0100, Vincent Sanders wrote:
>> >>>> From: Vincent Sanders <vince@collabora.co.uk>
>> >>>>
>> >>>> The constructor symbol name is different between platforms. Allow this
>> >>>> to be selected by configuration and set suitable default values.
>> >>>>
>> >>>> Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
>> >>>> ---
>> >>>> include/asm-generic/vmlinux.lds.h |    6 +++---
>> >>>> init/Kconfig                      |    6 ++++++
>> >>>> kernel/module.c                   |    2 +-
>> >>>> 3 files changed, 10 insertions(+), 4 deletions(-)
>> >>>>
>> >>>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> >>>> index 8aeadf6..fd34808 100644
>> >>>> --- a/include/asm-generic/vmlinux.lds.h
>> >>>> +++ b/include/asm-generic/vmlinux.lds.h
>> >>>> @@ -471,9 +471,9 @@
>> >>>>  }
>> >>>>
>> >>>> #ifdef CONFIG_CONSTRUCTORS
>> >>>> -#define KERNEL_CTORS()  . = ALIGN(8);                      \
>> >>>> -                        VMLINUX_SYMBOL(__ctors_start) = .; \
>> >>>> -                        *(.ctors)                          \
>> >>>> +#define KERNEL_CTORS()  . = ALIGN(8);                                   \
>> >>>> +                        VMLINUX_SYMBOL(__ctors_start) = .;              \
>> >>>> +                        *(CONFIG_CONSTRUCTORS_NAME)                     \
>> >>>>                  VMLINUX_SYMBOL(__ctors_end) = .;
>> >>>
>> >>> What is wrong with adding both "standard" names for ctors uncnditionally?
>> >>> Like this:
>> >>>>                  *(.ctors)                          \
>> >>>> +                        *(.init_array)                     \
>> >>
>> >> That doesn't get rid of CONFIG_CONSTRUCTORS_NAME, because it's needed
>> >> in the module code.  Do you have a suggestion to solve that as well?
>> >
>> > Ping.
>>
>> Pinging this back to life.  I'd like to see GCOV for ARM eABI finally make it upstream.
>> So, any objections to this?  Should it be resubmitted?
>
> Why is CONFIG_CONSTRUCTORS_NAME needed in module code?

Because ARM eABI uses the .init_array section for C++ constructors,
rather than .ctors.
So the patch defined CONFIG_CONSTRUCTORS_NAME to set the correct section name
for ARM eABI while leaving non-ARM-eABI as before, .ctors.  Here are the changes
from the patch for reference:

diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..52181a1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -20,6 +20,12 @@ config CONSTRUCTORS
        bool
        depends on !UML

+config CONSTRUCTORS_NAME
+       string
+       depends on CONSTRUCTORS
+       default ".init_array" if ARM && AEABI
+       default ".ctors"
+
 config HAVE_IRQ_WORK
        bool

diff --git a/kernel/module.c b/kernel/module.c
index 78ac6ec..e5fad5e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2600,7 +2600,7 @@ static void find_module_sections(struct module
*mod, struct load_info *info)
        mod->unused_gpl_crcs = section_addr(info, "__kcrctab_unused_gpl");
 #endif
 #ifdef CONFIG_CONSTRUCTORS
-       mod->ctors = section_objs(info, ".ctors",
+       mod->ctors = section_objs(info, CONFIG_CONSTRUCTORS_NAME,
                                  sizeof(*mod->ctors), &mod->num_ctors);
 #endif

W/o the above, GCOV does not work on ARM eABI for kernel modules.
Meanwhile, it still works as before for non-ARM-eABI kernel modules.

Thanks!

--
Regards,
George
