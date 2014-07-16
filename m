Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751AbaGPG3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:29:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54634 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070AbaGPG3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:29:15 -0400
Date: Wed, 16 Jul 2014 08:29:03 +0200
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] printk: Provide pi_<level> / pe_<level> macros
 for __init / __exit code
Message-ID: <20140716062903.GA15444@jig.fritz.box>
References: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
 <1405176212-12175-3-git-send-email-minipli@googlemail.com>
 <20140715162330.f9b18b79c0f32b84cb7a9071@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715162330.f9b18b79c0f32b84cb7a9071@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:23:30PM -0700, Andrew Morton wrote:
> On Sat, 12 Jul 2014 16:43:26 +0200 Mathias Krause <minipli@googlemail.com> wrote:
> 
> > The memory used for functions marked with __init will be released after
> > initialization, albeit static data referenced by such code will not, if
> > not explicitly marked this way, too. This is especially true for format
> > strings used in messages printed by such code. Those are not marked and
> > therefore will survive the __init cleanup -- dangling in memory without
> > ever being referenced again.
> > 
> > Ideally we would like the compiler to automatically recognise such
> > constructs but it does not and it's not as simple as it might sound, as
> > strings used in initialization code might latter still be used, e.g. as
> > a slab cache name. Therefore we need to explicitly mark the strings we
> > want to release together with the function itself.
> > 
> > For a seamless integration of the necessary __init_str() / __exit_str()
> > macros to mark the format strings, this patch provides new variants of
> > the well known pr_<level>() macros as pi_<level>() for __init code and
> > pe_<level>() for __exit code. Changing existing code should thereby be
> > as simple as changing a single letter.
> > 
> > For code that cannot be changed to use the pi_<level>() / pe_<level>()
> > macros printk_init() and printk_exit() macros are provided, too.
> > 
> > One remark, though: We cannot provide appropriate p[ie]_debug() macros
> > for the CONFIG_DYNAMIC_DEBUG case as there is (currently) no way to
> > remove entries from dyndbg after initialization. But supporting that
> > scenario would require more work (and code), therefore not necessarily
> > justifying the memory savings.
> 
> I assume that if a programmer gets this wrong,
> CONFIG_DEBUG_SECTION_MISMATCH will detect and report the error?

Yes it does. Very much the same as it detects wrong __init / __exit code
annotations. For wrong uses of the pi_*() / pe_*() helpers or manually
__init_str / __exit_str annotated strings modpost will detect all of the
following cases (8 wrong uses in total: 4 wrong pi_info / pe_info and 4
wrong __init_str / __exit_str annotations):

  void __init init_fun(void)
  {
  	pe_info("%s: Wrong use of pe_*() and __exit_str() in __init code\n",
  		__exit_str("init test"));
  }

  void normal_fun(void)
  {
  	pi_info("%s: Wrong use of pi_*() and __init_str() in normal code\n",
  		__init_str("normal test"));
  	pe_info("%s: Wrong use of pe_*() and __exit_str() in normal code\n",
  		__exit_str("normal test"));
  }

  void __exit exit_fun(void)
  {
  	pi_info("%s: Wrong use of pi_*() and __init_str() in __exit code\n",
  		__init_str("exit test"));
  }

Those will be detected either rather silently with the following message:

WARNING: modpost: Found 8 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

Or, with CONFIG_DEBUG_SECTION_MISMATCH=y, rather verbose:

WARNING: lib/test_module.o(.text+0x4): Section mismatch in reference from the function normal_fun() to the variable .init.rodata:__UNIQUE_ID__init_str_3
The function normal_fun() references
the variable __initconst __UNIQUE_ID__init_str_3.
This is often because normal_fun lacks a __initconst
annotation or the annotation of __UNIQUE_ID__init_str_3 is wrong.

WARNING: lib/test_module.o(.text+0xb): Section mismatch in reference from the function normal_fun() to the variable .init.rodata:__UNIQUE_ID__init_str_2
The function normal_fun() references
the variable __initconst __UNIQUE_ID__init_str_2.
This is often because normal_fun lacks a __initconst
annotation or the annotation of __UNIQUE_ID__init_str_2 is wrong.

WARNING: lib/test_module.o(.text+0x1c): Section mismatch in reference from the function normal_fun() to the variable .exit.data:__UNIQUE_ID__exit_str_5
The function normal_fun() references a variable in an exit section.
Often the variable __UNIQUE_ID__exit_str_5 has valid usage outside the exit section
and the fix is to remove the __exitdata annotation of __UNIQUE_ID__exit_str_5.

WARNING: lib/test_module.o(.text+0x25): Section mismatch in reference from the function normal_fun() to the variable .exit.data:__UNIQUE_ID__exit_str_4
The function normal_fun() references a variable in an exit section.
Often the variable __UNIQUE_ID__exit_str_4 has valid usage outside the exit section
and the fix is to remove the __exitdata annotation of __UNIQUE_ID__exit_str_4.

WARNING: lib/test_module.o(.init.text+0x4): Section mismatch in reference from the function init_fun() to the variable .exit.data:__UNIQUE_ID__exit_str_1
The function __init init_fun() references
a variable __exitdata __UNIQUE_ID__exit_str_1.
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exitdata annotation of
__UNIQUE_ID__exit_str_1 so it may be used outside an exit section.

WARNING: lib/test_module.o(.init.text+0xb): Section mismatch in reference from the function init_fun() to the variable .exit.data:__UNIQUE_ID__exit_str_0
The function __init init_fun() references
a variable __exitdata __UNIQUE_ID__exit_str_0.
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exitdata annotation of
__UNIQUE_ID__exit_str_0 so it may be used outside an exit section.

WARNING: lib/test_module.o(.exit.text+0x4): Section mismatch in reference from the function exit_fun() to the variable .init.rodata:__UNIQUE_ID__init_str_7
The function __exit exit_fun() references
a variable __initconst __UNIQUE_ID__init_str_7.
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __initconst annotation of
__UNIQUE_ID__init_str_7 so it may be used outside an init section.

WARNING: lib/test_module.o(.exit.text+0xb): Section mismatch in reference from the function exit_fun() to the variable .init.rodata:__UNIQUE_ID__init_str_6
The function __exit exit_fun() references
a variable __initconst __UNIQUE_ID__init_str_6.
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __initconst annotation of
__UNIQUE_ID__init_str_6 so it may be used outside an init section.


I'll see if I can make modpost detect the __UNIQUE_ID__init_str_* /
__UNIQUE_ID__exit_str_* variables and emit a more fitting message in
this case.

> 
> Please thoroughly test this if you have not done so.

I'll add the above in a more condensed form to the patch description as
this question came up for the second time, by now.


Thanks,
Mathias
