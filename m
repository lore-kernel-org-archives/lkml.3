Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3CKRhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:37:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3CKRhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:37:10 -0400
Date: Mon, 11 Mar 2013 13:36:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: zhangyanfei@cn.fujitsu.com, kexec@lists.infradead.org,
        heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
        lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com
Subject: Re: [PATCH v2 01/20] vmcore: refer to e_phoff member explicitly
Message-ID: <20130311173650.GG8482@redhat.com>
References: <20130302083554.31252.30615.stgit@localhost6.localdomain6>
 <5135A054.7010401@cn.fujitsu.com>
 <513C2C47.5020008@cn.fujitsu.com>
 <20130311.093141.331282420.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130311.093141.331282420.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 09:31:41AM +0900, HATAYAMA Daisuke wrote:
> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Subject: Re: [PATCH v2 01/20] vmcore: refer to e_phoff member explicitly
> Date: Sun, 10 Mar 2013 14:46:31 +0800
> 
> > 于 2013年03月05日 15:35, Zhang Yanfei 写道:
> >> 于 2013年03月02日 16:35, HATAYAMA Daisuke 写道:
> <cut>
> > 
> > One minor suggestion.
> > 
> > Previously, when the code assumes program headers are following immediately
> > the ELF header, it uses
> > 
> >  elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
> > 
> > to calculate the size of ELF header and ELF program headers
> > 
> > This patch avoids the assumption, and uses ehdr.e_phoff to get the program
> > headers' address. But it will read unrelated contents into elfcorebuf if
> > program headers are not following immediately the ELF header. So could the
> > code be:
> > 
> > elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
> > addr = elfcorehdr_addr + ehdr.e_phoff;
> > memcpy(elfcorebuf, &ehdr, sizeof(Elf64_Ehdr));
> > read_from_oldmem(elfcorebuf + sizeof(Elf64_Ehdr), elfcorebuf_sz -
> >                  sizeof(Elf64_Ehdr), &addr, 0);
> > (Elf64_Ehdr *)elfcorebuf->e_phoff = sizeof(Elf64_Ehdr);
> 
> Thanks. This is not minor suggestion. This is critical. My code is
> completely broken. On ELF, segments and headers other than ELF header
> can occur in any positions. This means program header table can occur
> after segments. So, on terabyte systems, e_phoff can be more than
> terabytes.

Agreed. It is safer to not copy al the bits till e_phoff.

Thanks
Vivek
