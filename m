Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3ENFvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:51:21 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56409 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3ENFvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:51:20 -0400
MIME-Version: 1.0
In-Reply-To: <5190DEA1.7030901@gmail.com>
References: <5190DEA1.7030901@gmail.com>
Date: Mon, 13 May 2013 22:51:19 -0700
X-Google-Sender-Auth: G9xHgdlsd3EfmyB0w_T-_4J1t6I
Message-ID: <CAE9FiQUAdTLjvvJRJsergZfpORyuVqneWt7NH_wUGCaS6buK3w@mail.gmail.com>
Subject: Re: [PATCH] x86, 64bit: Fix a possible bug in switchover in head_64.S
From: Yinghai Lu <yinghai@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: multipart/mixed; boundary=089e0111d424ed1e4f04dca73864
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0111d424ed1e4f04dca73864
Content-Type: text/plain; charset=ISO-8859-1

On Mon, May 13, 2013 at 5:37 AM, Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:
> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> It seems line 119 has a potential bug there. For example,
> the kernel is loaded at physical address 511G+1008M, that is
>     000000000 111111111 111111000 000000000000000000000
> and the kernel _end is 512G+2M, that is
>     000000001 000000000 000000001 000000000000000000000
> So in this example, when using the 2nd page to setup PUD (line 114~119),
> rax is 511.
> In line 118, we put rdx which is the address of the PMD page (the 3rd page)
> into entry 511 of the PUD table. But in line 119, the entry we calculate from
> (4096+8)(%rbx,%rax,8) has exceeded the PUD page. IMO, the entry in line
> 119 should be wraparound into entry 0 of the PUD table.
>
> Sorry for not having a machine with memory exceeding 512GB, so I cannot
> test to see if my guess is right or not. Please correct me if I am wrong.
>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  arch/x86/kernel/head_64.S |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 08f7e80..2395d8f 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -116,8 +116,13 @@ startup_64:
>         shrq    $PUD_SHIFT, %rax
>         andl    $(PTRS_PER_PUD-1), %eax
>         movq    %rdx, (4096+0)(%rbx,%rax,8)
> +       cmp     $511, %rax
> +       je      1f
>         movq    %rdx, (4096+8)(%rbx,%rax,8)
> -
> +       jmp     2f
> +1:
> +       movq    %rdx, (4096)(%rbx)
> +2:
>         addq    $8192, %rbx
>         movq    %rdi, %rax
>         shrq    $PMD_SHIFT, %rdi

yes, that is problem.

I did test the code cross before for cross 1T and 2T.
maybe we do not access the code during switch...

change could be more simple and avoid jmps.

please check attached, and it does not use jmp

index 08f7e80..321d65e 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -115,8 +115,10 @@ startup_64:
  movq %rdi, %rax
  shrq $PUD_SHIFT, %rax
  andl $(PTRS_PER_PUD-1), %eax
- movq %rdx, (4096+0)(%rbx,%rax,8)
- movq %rdx, (4096+8)(%rbx,%rax,8)
+ movq %rdx, 4096(%rbx,%rax,8)
+ incl %eax
+ andl $(PTRS_PER_PUD-1), %eax
+ movq %rdx, 4096(%rbx,%rax,8)

  addq $8192, %rbx
  movq %rdi, %rax

And we need cc to stable.

Yinghai

--089e0111d424ed1e4f04dca73864
Content-Type: application/octet-stream; name="fix_wrap.patch"
Content-Disposition: attachment; filename="fix_wrap.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgontpye0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9oZWFkXzY0LlMgYi9hcmNoL3g4Ni9rZXJuZWwv
aGVhZF82NC5TCmluZGV4IDA4ZjdlODAuLjMyMWQ2NWUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tl
cm5lbC9oZWFkXzY0LlMKKysrIGIvYXJjaC94ODYva2VybmVsL2hlYWRfNjQuUwpAQCAtMTE1LDgg
KzExNSwxMCBAQCBzdGFydHVwXzY0OgogCW1vdnEJJXJkaSwgJXJheAogCXNocnEJJFBVRF9TSElG
VCwgJXJheAogCWFuZGwJJChQVFJTX1BFUl9QVUQtMSksICVlYXgKLQltb3ZxCSVyZHgsICg0MDk2
KzApKCVyYngsJXJheCw4KQotCW1vdnEJJXJkeCwgKDQwOTYrOCkoJXJieCwlcmF4LDgpCisJbW92
cQklcmR4LCA0MDk2KCVyYngsJXJheCw4KQorCWluY2wJJWVheAorCWFuZGwJJChQVFJTX1BFUl9Q
VUQtMSksICVlYXgKKwltb3ZxCSVyZHgsIDQwOTYoJXJieCwlcmF4LDgpCiAKIAlhZGRxCSQ4MTky
LCAlcmJ4CiAJbW92cQklcmRpLCAlcmF4Cg==
--089e0111d424ed1e4f04dca73864--
