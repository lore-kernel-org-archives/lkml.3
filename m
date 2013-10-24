Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3JXLYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:24:36 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2034 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3JXLYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:24:34 -0400
X-Spam-Score: -100.8
Message-ID: <5269032E.2060400@asianux.com>
Date: Thu, 24 Oct 2013 19:23:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
References: <5267AE7D.4080600@asianux.com> <C2D7FE5348E1B147BCA15975FBA23075152B30@IN01WEMBXA.internal.synopsys.com> <52688C42.3030907@asianux.com> <CAMuHMdWD1ENyrBMimnoYQc4hzJ_Zkob-1RQ3F+wXbSktYcO9xQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWD1ENyrBMimnoYQc4hzJ_Zkob-1RQ3F+wXbSktYcO9xQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 04:30 PM, Geert Uytterhoeven wrote:
> On Thu, Oct 24, 2013 at 4:56 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> NAK.
>>
>> OK, thanks. At least this patch is incorrect.
>>
>>
>>> ARC will never have VGA console. You need to add !ARC to relevant Kconfig. However that approach is frowned upon in general. The current way to doing such things is to define a new Kconfig item which relevant arches can select.
>>
>> Hmm... it seems necessary to discuss about the 2 fixing ways (which
>> already had a long discussion in ARM64):
>>
>>  - add !ARC in related place, just like another (almost 30-40%) architectures done.
>>
>>  - add a new Kconfig item (e.g. HAVE_VGA_CONSOLE), and let the left (almost 50%) architectures which use VGA_CONSOLE to set it.
>>
>> Catalin, Will, Geert (it seems also include you) prefer 2nd way, but I
>> prefer 1st, my reasons are below, please help check:
>>
>>  - 1st way need add some (10-20%) of architectures in one place, which belongs to local wide.
>>    2nd way will let the left (almost 50%) architectures need add HAVE_VGA_CONSOLE in various place, which belongs to arch global wide.
>>
>>  - 1st way will let most (80-90%) of architectures don't care about VGA_CONSOLE (50% need it, 30-40% already mark it in the same place).
>>    2nd way will let 50% architectures care about VGA_CONSOLE (although can let the left 10-20% architectures do nothing -- not care about it).
>>
>>  - 1st way is still easy, sustainable, and clear enough in local wide fixing (although maybe it is not the best, or clearest way).
>>    2nd way is also easy, sustainable and clear enough (maybe the best, or clearest for 10-20% architectures), but it will let the fix in global wide
>>
>> All together, if we can bear and sustainable, I always prefer to fix it
>> in local wide, not lead to arch global (especially 80-90% architectures
>> already followed 1st way).
>>
>>
>> BTW: for me, if less than 20% architectures need XXX, we can trigger
>> defining a new Kconfig item (e.g. HAVE_XXX), or just follow original
>> implementation.
> 
> Lot's of negative dependencies are missing for VGA_CONSOLE.
> I think only alpha, some arm, ia64, some mips, some powerpc, and x86
> may use it.
> 

in "arch" sub-directory, contents 13/30 (43.3%) architectures contents
VGA_CONSOLE.

  1 alpha/kernel/setup.c:137:struct screen_info screen_info = {
  2 arm/kernel/setup.c:743:struct screen_info screen_info = {
  3 cris/kernel/setup.c:28:struct screen_info screen_info;
  4 ia64/kernel/setup.c:79:struct screen_info screen_info;
  5 m32r/kernel/setup.c:55:struct screen_info screen_info = {
  6 mips/kernel/setup.c:43:struct screen_info screen_info;
  7 powerpc/kernel/setup-common.c:88:struct screen_info screen_info = {
  8 score/kernel/setup.c:37:struct screen_info screen_info;
  9 sh/kernel/setup.c:68:struct screen_info screen_info;
 10 sparc/kernel/setup_64.c:66:struct screen_info screen_info = {
 11 sparc/kernel/setup_32.c:53:struct screen_info screen_info = {
 12 tile/kernel/setup.c:54:struct screen_info screen_info;
 13 x86/kernel/setup.c:220:struct screen_info screen_info;
 14 xtensa/kernel/setup.c:55:struct screen_info screen_info = { 0, 24, 0, 0, 0, 80, 0, 0, 0, 24, 1, 16};

It seems most of pc and servers support VGA_CONSOLE.


> The main reason for introducing HAVE_VGA_CONSOLE is maintainability.
> The question to ask is: does the logic have to change when adding a new
> architecture?
>   - If yes, you're better off with the HAVE_xxx scheme.
>   - If no, use the negative dependencies in the common place.
> 

Yeah, it sounds reasonable to me, originally I really do not notice
about it, in my default memory, VGA_CONSOLE is commonly used, so not
care about this item (my most experience are under pc and server).

> VGA consoles are legacy, and not used on new systems. Witness the
> list of architectures I gave above. All of them are (at least) 20 years old
> (except for ia64, but that borrows from PC legacy).
> So every time when adding a new architecture, you have to add
> '&& !NEW_ARCH' to the VGA_CONSOLE dependency, which is in a
> common place (drivers/.../Kconfig).
> While with the HAVE_xxx scheme, you don't have to change anything.
> 

Are you sure about it? (especially for a new server or pc comes).

Hmm... at least, I am not quite familiar about it, if really as what
you said (e.g. acked-by another members), I will support you, too.

If what you said is correct, could you help to send related patch for
it? if I send this kind of patches, it will be easily redirected to
"/dev/null".


> Compare this to a shiny new feature that available on all new architectures,
> but not on a few old one. There it makes sense to have the negative
> dependencies on the old architectures, that will never have the new feature.
> While new architectures have enabled it by default.
> 

Excuse me, my English is not quite well, I do not quite understand your
meaning, but it seems not quite important for our discussing, so I just
skip it, now.

If you feel they are necessary contents, please help to repeat again.

thanks.


> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
> 


-- 
Chen Gang
