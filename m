Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3EFHym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:54:42 -0400
Received: from ozlabs.org ([203.10.76.45]:54332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab3EFHyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:54:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tom Rini <trini@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] modpost.c: Add .text.unlikely to TEXT_SECTIONS
In-Reply-To: <51815BA0.1090209@ti.com>
References: <1366842363-7513-1-git-send-email-trini@ti.com> <87sj2aca9r.fsf@rustcorp.com.au> <517E7260.5070204@ti.com> <87ppxbxwzg.fsf@rustcorp.com.au> <5180F9FB.8010307@ti.com> <51815BA0.1090209@ti.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 06 May 2013 14:54:47 +0930
Message-ID: <87fvy0r880.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Rini <trini@ti.com> writes:
> On 05/01/2013 07:18 AM, Tom Rini wrote:
>> On 04/30/2013 10:19 PM, Rusty Russell wrote:
>>> Tom Rini <trini@ti.com> writes:
>>>> On 04/28/2013 10:59 PM, Rusty Russell wrote:
>>>>> Tom Rini <trini@ti.com> writes:
>>>>>
>>>>>> Recent gcc's may place functions into the .text.unlikely section and we
>>>>>> need to check this section as well for section mismatches now otherwise
>>>>>> we may have false negatives for this test.
>>>>>
>>>>> Hmm, I don't think it's all that recent, is it?  I can find it back to
>>>>> gcc 4.0.4:
>>>>>
>>>>> `-freorder-functions'
>>>>>      Reorder functions in the object file in order to improve code
>>>>>      locality.  This is implemented by using special subsections
>>>>>      `.text.hot' for most frequently executed functions and
>>>>>      `.text.unlikely' for unlikely executed functions.  Reordering is
>>>>>      done by the linker so object file format must support named
>>>>>      sections and linker must place them in a reasonable way.
>>>>>
>>>>>      Also profile feedback must be available in to make this option
>>>>>      effective.  See `-fprofile-arcs' for details.
>>>>>
>>>>>      Enabled at levels `-O2', `-O3', `-Os'.
>>>>>
>>>>> The comment is the same in in gcc 4.7.
>>>>>
>>>>> So is your real issue that this section is generated with
>>>>> -fprofile-arcs, or has something changed with gcc 4.8, or...?
>>>>
>>>> I've started seeing this with Linaro based 4.7 toolchains.  I can go
>>>> back through their releases and see when it starts showing up there if
>>>> it helps.  I didn't add .text.hot as I didn't have that section at all,
>>>> fwiw.
>>>
>>> Weird, did you turn on CONFIG_GCOV_KERNEL?  AFAICT you shouldn't see
>>> this section without that.
>> 
>> Nope, CONFIG_GCOV_KERNEL is off.  Must be related to whatever flags the
>> Linaro folks set as default on -O2 (at least in their 2013.03 release),
>> after reading over one of the .o.cmd files in the build.
>> 
>> Do you want me to re-word the commit message a bit or ?  Thanks!
>
> I poked around, and every Linaro binary I can grab (2012.01 and gcc 4.6
> to 2013.04 and gcc 4.8) has this behaviour.

I should have checked earlier; happens here too.  Looks like a
documentation bug.  I've filed it here:

        http://gcc.gnu.org/bugzilla/show_bug.cgi?id=57182

So I reworded it slightly, and applied.

Thanks!
Rusty.

From: Tom Rini <trini@ti.com>
Subject: modpost.c: Add .text.unlikely to TEXT_SECTIONS

gcc's places cold functions into the .text.unlikely section and we
need to check this section as well for section mismatches otherwise we
may have false negatives for this test.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Tom Rini <trini@ti.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (wording update)
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a4be8e1..3d155dd 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -884,7 +884,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
 
 #define DATA_SECTIONS ".data$", ".data.rel$"
-#define TEXT_SECTIONS ".text$"
+#define TEXT_SECTIONS ".text$", ".text.unlikely$"
 
 #define INIT_SECTIONS      ".init.*"
 #define CPU_INIT_SECTIONS  ".cpuinit.*"




