Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaBMAdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:33:44 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48572 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaBMAdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:33:42 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-40-52fc12e31f8b
Message-ID: <52FC12E3.9060300@lge.com>
Date: Thu, 13 Feb 2014 09:33:39 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [BUG] perf report/annotate: consuming too many file descriptors
References: <CABPqkBSzttXoe3f_jC=Fv+ieN7_TNxLMDs4CH1C0TLYRq+Oz7g@mail.gmail.com>
In-Reply-To: <CABPqkBSzttXoe3f_jC=Fv+ieN7_TNxLMDs4CH1C0TLYRq+Oz7g@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030908040302000509050709"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030908040302000509050709
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Stephane,

(I'd be better if you use my korg address).

2014-02-12 PM 11:32, Stephane Eranian wrote:
> Hi,
>
>
> I was testing 3.14-rc2 (tip.git) perf and ran into a serious problem
> with report/annotate on a collection with lots of shared libraries (500).
>
> Perf ran out of file descriptors (ulimit set to 1024). It did not print
> an error message, but simply refused to proceed to objdump.
>
> I ran strace and discovered it was running out of descriptors to
> my big surprise! I narrowed it down with strace -etrace=open.
> I saw an appalling result.
>
> My .so files were opened at least 4 times each, each
> allocated an fd that was kept open, each open incur a read of the ELF
> headers. So each dso was consuming 4 fd.
>
> Why?
>
> Because of what's going on in dso__load() when perf iterates
> over the binary_type_symtab[]. It tries a bunch of types. For
> each match, symsrc_init() is invoked to read the ELF image.
> The fd opened there is kept open (for later loading).
>
> The first problem is why is dso__read_binary_type_filename()
> blindly returning success on many types. For my files, I got matches
> on DEBUGLINK, SYSTEM_DSO_PATH, GUEST_KMODULE,
> SYSTEM_PATH_KMODULE.
>
> I have a tendency to believe that the dso__read_binary_type_filename()
> meaning has been abused to stash things that do not really
> belong there.
>
> Furthermore, I believe many of the type matches do NOT need an ELF
> read and certainly not one that keeps a descriptor opened.
>
> This problem is not just about consuming too many fd, it is also about
> execution overhead. Why read the ELF headers 4 times?
>
> The current situation makes reporting on large collection impossible for
> regular users. I don't quite know how to best address this issue. One way
> I found would be for  dso__read_binary_type_filename() to return a value
> meaning success but no ELF read. Not sure would be correct, though.

It looks like a case of stripped binary or static build.  dso__load() 
looked for both of symtab and dynsym, but it failed.  So it iterated 
through the binary types and continued to fail with fd open. :(

I think we should close/destroy the duplicate symsrcs.  Does attached 
patch fix your problem?

Thanks,
Namhyung


--------------030908040302000509050709
Content-Type: text/plain; charset=x-windows-949;
 name="destory-unnecessary-symsrc.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="destory-unnecessary-symsrc.patch"

ZGlmZiAtLWdpdCBhL3Rvb2xzL3BlcmYvdXRpbC9zeW1ib2wuYyBiL3Rvb2xzL3BlcmYvdXRp
bC9zeW1ib2wuYwppbmRleCBhYmViYzI1OTE5NjAuLmNkOTcwMTA2ZGU5OSAxMDA2NDQKLS0t
IGEvdG9vbHMvcGVyZi91dGlsL3N5bWJvbC5jCisrKyBiL3Rvb2xzL3BlcmYvdXRpbC9zeW1i
b2wuYwpAQCAtMTMzNyw2ICsxMzM3LDggQEAgaW50IGRzb19fbG9hZChzdHJ1Y3QgZHNvICpk
c28sIHN0cnVjdCBtYXAgKm1hcCwgc3ltYm9sX2ZpbHRlcl90IGZpbHRlcikKIAogCQkJaWYg
KHN5bXNfc3MgJiYgcnVudGltZV9zcykKIAkJCQlicmVhazsKKwkJfSBlbHNlIHsKKwkJCXN5
bXNyY19fZGVzdHJveShzcyk7CiAJCX0KIAogCX0K
--------------030908040302000509050709--
