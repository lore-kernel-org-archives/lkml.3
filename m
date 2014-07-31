Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaGaTko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:40:44 -0400
Received: from mail.us.es ([193.147.175.20]:36674 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbaGaTkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:40:41 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19250. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-102.4/7.5):. 
 Processed in 1.837385 secs); 31 Jul 2014 19:40:39 -0000
X-Spam-ASN: AS42863 46.50.0.0/17
X-Envelope-From: pneira@us.es
Date: Thu, 31 Jul 2014 21:40:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 5/5] net: filter: split 'struct sk_filter'
 into socket and bpf parts
Message-ID: <20140731194059.GA8681@salvia>
References: <1406777656-27755-1-git-send-email-ast@plumgrid.com>
 <1406777656-27755-6-git-send-email-ast@plumgrid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406777656-27755-6-git-send-email-ast@plumgrid.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 08:34:16PM -0700, Alexei Starovoitov wrote:
> clean up names related to socket filtering and bpf in the following way:
> - everything that deals with sockets keeps 'sk_*' prefix
> - everything that is pure BPF is changed to 'bpf_*' prefix
> 
> split 'struct sk_filter' into
> struct sk_filter {
> 	atomic_t        refcnt;
> 	struct rcu_head rcu;
> 	struct bpf_prog *prog;
> };

I think you can use 'struct bpf_prog prog' instead so the entire
sk_filter remains in the same memory blob (as it is before this
patch).

You can add an inline function to retrieve the bpg prog from the
filter:

static inline struct bpf_prog *sk_filter_bpf(struct sk_filter *)

and use it whenever possible to fetch the bpf program. I'm suggesting
this because we can use the zero array size in the socket filtering
abstraction later on, if the function above is used, this just needs
one line in that function to be updated to fetch the program from the
placeholder.
