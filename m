Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3LKI0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:26:25 -0500
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:41449 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751191Ab3LKI0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:26:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 82,6.414,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:418:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4034:4321:5007:7652:7903:8603:10013:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:13618,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:2:0
X-HE-Tag: ball34_371857c179208
X-Filterd-Recvd-Size: 3176
Message-ID: <1386750377.8168.37.camel@joe-AO722>
Subject: Re: [PATCH -next 2/3] batman-adv: Use seq_overflow
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <antonio@meshcoding.com>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Dec 2013 00:26:17 -0800
In-Reply-To: <20131211080504.GT10323@ZenIV.linux.org.uk>
References: <cover.1386738050.git.joe@perches.com>
	 <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com>
	 <20131211075526.GR10323@ZenIV.linux.org.uk>
	 <20131211080504.GT10323@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 08:05 +0000, Al Viro wrote:
> On Wed, Dec 11, 2013 at 07:55:26AM +0000, Al Viro wrote:
> 
> > This sucker should return 0.  Insufficiently large buffer will be handled
> > by caller, TYVM, if you give that caller a chance to do so.  Returning 1
> > from ->show() is a bug in almost all cases, and definitely so in this one.
> > 
> > Just in case somebody decides that above is worth copying: It Is Not.
> > Original code is buggy, plain and simple.  This one trades the older
> > bug ("fail with -EINVAL whenever the buffer is too small") with just as buggy
> > "silently skip an entry entirely whenever the buffer is too small".
> > 
> > Don't Do That.
> 
> Pardon - Joe has made seq_overflow return -1 instead of true.  Correction
> to the above, then - s/This trades.*\./This is just as buggy./

Yeah, I started to use true/false, 0/1, but thought
I needed to match what seq_printf/seq_vprintf does.

> Conclusion is still the same - Don't Do That.  Returning -1 on insufficiently
> large buffer is a bug, plain and simple.

int seq_vprintf(struct seq_file *m, const char *f, va_list args)
{
	int len;

	if (m->count < m->size) {
		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
		if (m->count + len < m->size) {
			m->count += len;
			return 0;
		}
	}
	seq_set_overflow(m);
	return -1;
}
EXPORT_SYMBOL(seq_vprintf);

int seq_printf(struct seq_file *m, const char *f, ...)
{
	int ret;
	va_list args;

	va_start(args, f);
	ret = seq_vprintf(m, f, args);
	va_end(args);

	return ret;
}
EXPORT_SYMBOL(seq_printf);

> And this patch series is completely misguided - it doesn't fix any bugs
> *and* it provides a misleading example for everyone.  See the reaction
> right in this thread, proposing to spread the same bug to currently
> working iterators.

Anyway, changing seq_overflow is easy enough

You prefer this?

bool seq_overflow(struct seq_file *seq)
{
	return m->count == m->size;
}


