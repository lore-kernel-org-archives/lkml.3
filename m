Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaIBVff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:35:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44656 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbaIBVfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:35:32 -0400
Message-Id: <1409693731.1032736.162879961.54F4A55B@webmail.messagingengine.com>
X-Sasl-Enc: iUJkbzChOy3gJgpcplGSME3teJJxG2UVkOcFmNS+vVQL 1409693731
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Kees Cook <keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-73bced9a
Subject: Re: [PATCH net-next v2] net: bpf: make eBPF interpreter images read-only
Date: Tue, 02 Sep 2014 23:35:31 +0200
In-Reply-To: <CAMEtUuyoWELJ0Yf+=5sDKxFEfgsiQ3kMCK+Wn_bdJgS8qaH2og@mail.gmail.com>
References: <aa5126f747594d768e0c518189a13e8674ad8ee5.1409690486.git.hannes@stressinduktion.org>
 <2bf2e54282097642db88e2b596b06a9ac3742883.1409690849.git.hannes@stressinduktion.org>
 <CAMEtUuyoWELJ0Yf+=5sDKxFEfgsiQ3kMCK+Wn_bdJgS8qaH2og@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014, at 23:31, Alexei Starovoitov wrote:
> On Tue, Sep 2, 2014 at 1:53 PM, Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
> > From: Daniel Borkmann <dborkman@redhat.com>
> >
> > With eBPF getting more extended and exposure to user space is on it's way,
> > hardening the memory range the interpreter uses to steer its command flow
> > seems appropriate.  This patch moves the to be interpreted bytecode to
> > read-only pages.
> ...
> >  11 files changed, 144 insertions(+), 32 deletions(-)
> 
> nice. quite short.
> 
> > +#ifdef CONFIG_DEBUG_SET_MODULE_RONX
> > +static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
> > +{
> > +       set_memory_ro((unsigned long)fp, fp->pages);
> 
> since ronx are ifdef checked together,
> would probably make sense to set nx too?

NX bit is already set, because we didn't request page with
PAGE_KERNEL_EXEC.

E.g. in kernel_page_tables:
0xffffc90000a94000-0xffffc90000a96000           8K     ro            
GLB NX pte

> > +static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
> > +{
> > +       set_memory_rw((unsigned long)fp, fp->pages);
> 
> why rw is needed?
> since fp is allocated with vmalloc, vfree doesn't need
> to touch the pages to free them, no?

We will check that. It basically was copied from jit hardening code.
Maybe we can omit the call.

Thanks,
Hannes
