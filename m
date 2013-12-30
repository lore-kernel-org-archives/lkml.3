Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3L3V5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:57:08 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50828 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932222Ab3L3V5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:57:06 -0500
X-Sasl-enc: 8RDuG8tR/qEYX+IO3xH5nKLfRxEGJYQzyVzkEIzAynRb 1388440624
Date: Mon, 30 Dec 2013 19:57:01 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
Message-ID: <20131230215701.GA4938@khazad-dum.debian.net>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
 <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>
 <1388429761.4410.1.camel@jlt4.sipsolutions.net>
 <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6>
 <1388438724.4573.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388438724.4573.2.camel@jlt4.sipsolutions.net>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Johannes Berg wrote:
> On Mon, 2013-12-30 at 20:58 +0100, Julia Lawall wrote:
> > > Is there any way we could catch (sparse, or some other script?) that
> > > struct reorganising won't break the condition needed ("within a
> > > structure that contains at least two more bytes")?
> > 
> > What kind of reorganizing could happen?  Do you mean that the programmer 
> > might do at some time in the future, or something the compiler might do?
> 
> I'm just thinking of a programmer, e.g. changing a struct like this:
> 
>  struct foo {
>    u8 addr[ETH_ALEN];
> -  u16 dummy;
>  };
> 
> for example.

That is easily resolved by:

struct foo {
	u8 addr[ETH_ALEN];
	u16 required_padding;	/* do not remove upon pain of death */
};

Preferably with a comment nearby explaining just why that padding is so
important in the first place.

Unfortunately, we do have a lot of code with unexplained padding that one
should never remove, and it is often nowhere nearly as obvious as stray
elements with idiotic non-explanatory names in a structure.

One example is the via-rng hw_random driver, where the buffer used by the
"xstore" via-specific instriction *MUST* be longer than what the "xstore"
instruction is documented to require due to CPU errata (you ask it to write
from 1 to 8 bytes, and it may end up writing 16 bytes).  The xstore buffer
is an array that was made long enough to avoid the errata, but that fact is
documented only in a git commit message.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
