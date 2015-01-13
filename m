Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbbAMJY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:24:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbAMJY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:24:57 -0500
Date: Tue, 13 Jan 2015 10:19:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jolsa@kernel.org, namhyung@kernel.org, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, acme@kernel.org,
        masami.hiramatsu.pt@hitachi.com, jean.pihet@linaro.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH] perf: fix dwarf unwind using libunwind.
Message-ID: <20150113091928.GA2160@krava.brq.redhat.com>
References: <1421117677-51536-1-git-send-email-wangnan0@huawei.com>
 <20150113071059.GA32634@krava.brq.redhat.com>
 <54B4D925.3020906@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B4D925.3020906@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:36:53PM +0800, Wang Nan wrote:
> On 2015/1/13 15:10, Jiri Olsa wrote:
> > On Tue, Jan 13, 2015 at 10:54:37AM +0800, Wang Nan wrote:
> > 
> > SNIP
> > 
> >>  
> >> +static int elf_is_exec(int fd, const char *name)
> >> +{
> >> +	Elf *elf;
> >> +	GElf_Ehdr ehdr;
> >> +	int retval = 0;
> >> +
> >> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
> >> +	if (elf == NULL)
> >> +		return 0;
> >> +	if (gelf_getehdr(elf, &ehdr) == NULL)
> >> +		goto out;
> >> +
> >> +	retval = (ehdr.e_type == ET_EXEC);
> >> +
> >> +out:
> >> +	elf_end(elf);
> >> +	pr_debug("unwind: elf_is_exec(%s): %d\n", name, retval);
> >> +	return retval;
> >> +
> >> +}
> > 
> > yuou need to add stub for 'NO_LIBUNWIND_DEBUG_FRAME=1', otherwise:
> > 
> >   CC       util/dwarf-aux.o
> >   CC       util/unwind-libunwind.o
> > util/unwind-libunwind.c:188:12: error: ‘elf_is_exec’ defined but not used [-Werror=unused-function]
> >  static int elf_is_exec(int fd, const char *name)
> >             ^
> > cc1: all warnings being treated as errors
> > make[1]: *** [util/unwind-libunwind.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [all] Error 2
> > 
> > jirka
> > 
> 
> Thanks. I haven't test NO_LIBUNWIND_DEBUG_FRAME=1 case.
> 
> I found that it is possible to utilize map->dso->adjust_symbols for this propose so
> we don't need to introduce another function to check ehdr.e_type. However
> map->dso->adjust_symbols checks not only ET_EXEC but also ET_REL. What do you think?
> 
> I'd like to check it and post another patch.

please also update tests/mate

thanks,
jirka
