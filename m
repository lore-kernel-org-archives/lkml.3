Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaIBVbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:31:50 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:45173 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaIBVbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <2bf2e54282097642db88e2b596b06a9ac3742883.1409690849.git.hannes@stressinduktion.org>
References: <aa5126f747594d768e0c518189a13e8674ad8ee5.1409690486.git.hannes@stressinduktion.org>
	<2bf2e54282097642db88e2b596b06a9ac3742883.1409690849.git.hannes@stressinduktion.org>
Date: Tue, 2 Sep 2014 14:31:47 -0700
Message-ID: <CAMEtUuyoWELJ0Yf+=5sDKxFEfgsiQ3kMCK+Wn_bdJgS8qaH2og@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: bpf: make eBPF interpreter images read-only
From: Alexei Starovoitov <ast@plumgrid.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 1:53 PM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> From: Daniel Borkmann <dborkman@redhat.com>
>
> With eBPF getting more extended and exposure to user space is on it's way,
> hardening the memory range the interpreter uses to steer its command flow
> seems appropriate.  This patch moves the to be interpreted bytecode to
> read-only pages.
...
>  11 files changed, 144 insertions(+), 32 deletions(-)

nice. quite short.

> +#ifdef CONFIG_DEBUG_SET_MODULE_RONX
> +static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
> +{
> +       set_memory_ro((unsigned long)fp, fp->pages);

since ronx are ifdef checked together,
would probably make sense to set nx too?

> +static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
> +{
> +       set_memory_rw((unsigned long)fp, fp->pages);

why rw is needed?
since fp is allocated with vmalloc, vfree doesn't need
to touch the pages to free them, no?
