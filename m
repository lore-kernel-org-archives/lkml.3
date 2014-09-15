Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaIOSGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:06:54 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37975 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaIOSGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:06:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140911203806.GA25763@kernel.org>
References: <CAPp4yYwTHbXiypxR_1WJGS9DYQNJ24t_Ykdo_sfQ48Ak-K3Z7g@mail.gmail.com>
	<20140911150123.GH10158@kernel.org>
	<CAPp4yYzRwoTBzH1_TwcdvAOryZppV9-BwnX2bOtN1qrEqrdBww@mail.gmail.com>
	<20140911203806.GA25763@kernel.org>
Date: Mon, 15 Sep 2014 11:06:49 -0700
Message-ID: <CAPp4yYzT66+J_dHC5_0TiTEdSK874OS-PH9nAtcr5-Luj69+7w@mail.gmail.com>
Subject: Re: [PATCH 1/1] perf tools: Fix Symbol Address for ET_DYN
From: Tong Shen <endlessroad@google.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gentle ping :-)

On Thu, Sep 11, 2014 at 1:38 PM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Thu, Sep 11, 2014 at 11:21:40AM -0700, Tong Shen escreveu:
>> Hi Arnaldo,
>>
>> Thanks a lot for the comment!
>>
>> I fixed the coding style and added a helper function with comments, as
>> you suggested :-)
>> See attachment.
>
> That is much better, I'm adding lkml to the CC list so that we can give
> other people the opportunity to chime in.
>
> - Arnaldo
>
>> On Thu, Sep 11, 2014 at 8:01 AM, Arnaldo Carvalho de Melo
>> <acme@kernel.org> wrote:
>> > Em Fri, Sep 05, 2014 at 11:38:02AM -0700, Tong Shen escreveu:
>> >> Hi linux-perf-users,
>> >>
>> >> It's actually a patch, and I didn't find a development mailing list
>> >> for perf, so I just post it here. If this is not the right place to
>> >
>> > You can post it here, but please add the maintainers to the CC list, so
>> > that we can more quickly see your message.
>> >
>> > Comments below:
>> >
>> >> post patches, could someone direct me to it? Thanks in advance!
>> >>
>> >> In tools/perf/util/symbol-elf.c, we don't adjust symbol address for
>> >> ET_DYN type of ELF files because we think ET_DYN is always
>> >> relocatable.
>> >>
>> >> But that's not necessarily true; there are some non-relocatable ET_DYN
>> >> ELF files. For those files, we should still adjust symbol address.
>> >
>> >> Suggested patch: (HTML subpart now allowed in this mailing list...)
>> >
>> >> +++ b/perf-3.12.0/tools/perf/util/symbol-elf.c
>> >> @@ -915,7 +915,10 @@ int dso__load_sym(struct dso *dso, struct map *map,
>> >
>> >>               if ((used_opd && runtime_ss->adjust_symbols)
>> >> -                             || (!used_opd && syms_ss->adjust_symbols)) {
>> >> +                             || (!used_opd && syms_ss->adjust_symbols)
>> >> +                             || (syms_ss->ehdr.e_type == et_dyn
>> >> +                                     && shdr.sh_addr != shdr.sh_offset
>> >> +                                     && elf_sec__is_text(&shdr, secstrs))) {
>> >
>> > Please try to follow kernel coding style in these tools, i.e. the &&
>> > should be at the end, the expression on each line should be aligned just
>> > after the opening parens.
>> >
>> > If, like in this case, you find something not following that style, take
>> > the opportunity to fix it :-)
>> >
>> > But back to your change, I'll have to look at this code further, just
>> > looking at the excerpt above I find it way too confusing, and your patch
>> > makes it even more so...
>> >
>> > Can you introduce some suitably named helper that has those extra
>> > conditions you're adding now and then add it to this conditional?
>> >
>> > I.e. make it somethine like:
>> >
>> > -               if ((used_opd && runtime_ss->adjust_symbols)
>> > -                               || (!used_opd && syms_ss->adjust_symbols)) {
>> > +               if ((used_opd && runtime_ss->adjust_symbols) ||
>> > +                   (!used_opd && syms_ss->adjust_symbols)   ||
>> > +                   syms__some_suitable_name(syms_ss, &shdr)) {
>> >
>> > And then add your explanation of these kinds of files as a comment over
>> > this new function, please?
>> >
>> >>                       pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
>> >>                                 "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
>> >>                                 (u64)sym.st_value, (u64)shdr.sh_addr,
>> >
>> > Best regards,
>> >
>> > - Arnaldo
>>
>>
>>
>> --
>> Best Regards, Tong Shen
>
>> diff --git a/perf-3.12.0/tools/perf/util/symbol-elf.c b/perf-3.12.0/tools/perf/util/symbol-elf.c
>> index a9c829b..f9bd488 100644
>> --- a/perf-3.12.0/tools/perf/util/symbol-elf.c
>> +++ b/perf-3.12.0/tools/perf/util/symbol-elf.c
>> @@ -673,6 +673,27 @@ static u64 ref_reloc(struct kmap *kmap)
>>       return 0;
>>  }
>>
>> +/**
>> + * is_non_relocatable_dyn - check if ELF file is ET_DYN, but not relocatable
>> + * @ehdr: ELF header of the ELF file
>> + * @shdr: a section header in the ELF file
>> + *
>> + * For ELF files with type ET_EXEC and ET_REL, we adjust symbol addresses in
>> + * symbol table in dso__load_sym() so that later we can always locate symbols
>> + * by sym.st_value + map_address_of_ELF_file.
>> + *
>> + * But ELF files with type ET_DYN may need adjusting as well, if they are
>> + * not relocatable. There's no standard way to tell if an ELF file with type
>> + * ET_DYN is relocatable. One possible way to do that is checking if
>> + * sh_addr == sh_offset for .text section.
>> + */
>> +static bool is_non_relocatable_dyn(GElf_Ehdr *ehdr, GElf_Shdr *shdr,
>> +                                   Elf_Data *secstrs) {
>> +     return ehdr->e_type == ET_DYN &&
>> +            elf_sec__is_text(shdr, secstrs) &&
>> +            shdr->sh_offset != shdr->sh_addr;
>> +}
>> +
>>  int dso__load_sym(struct dso *dso, struct map *map,
>>                 struct symsrc *syms_ss, struct symsrc *runtime_ss,
>>                 symbol_filter_t filter, int kmodule)
>> @@ -914,8 +935,9 @@ int dso__load_sym(struct dso *dso, struct map *map,
>>                       goto new_symbol;
>>               }
>>
>> -             if ((used_opd && runtime_ss->adjust_symbols)
>> -                             || (!used_opd && syms_ss->adjust_symbols)) {
>> +             if ((used_opd && runtime_ss->adjust_symbols) ||
>> +                 (!used_opd && syms_ss->adjust_symbols) ||
>> +                 is_non_relocatable_dyn(&ehdr, &shdr, secstrs)) {
>>                       pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
>>                                 "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
>>                                 (u64)sym.st_value, (u64)shdr.sh_addr,
>



-- 
Best Regards, Tong Shen
