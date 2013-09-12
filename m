Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3ILAE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:04:27 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:49589 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750899Ab3ILAEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:04:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973
X-HE-Tag: mouth25_25a9c59c2b560
X-Filterd-Recvd-Size: 2776
Message-ID: <1378944257.4714.45.camel@joe-AO722>
Subject: Re: [RFC PATCH] vsnprintf: Remove use of %n and convert existing
 uses
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        keescook@chromium.org, fweisbec@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        tushar.behera@linaro.org, lidza.louina@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, courmisch@gmail.com, vyasevich@gmail.com,
        nhorman@tuxdriver.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org
Date: Wed, 11 Sep 2013 17:04:17 -0700
In-Reply-To: <201309120840.HHE37542.OJMFFHSOQOtVFL@I-love.SAKURA.ne.jp>
References: <1378926562.4714.11.camel@joe-AO722>
	 <CAGXu5jLO6109fkejXqX=WhkQnfAUeWtTcow0v1BNqyi=8=Qa3Q@mail.gmail.com>
	 <1378928700.4714.17.camel@joe-AO722>
	 <CAGXu5jLTjrPr=GwOmMcu55Qp9K-_XS75xq9NJ0vBUEwy-i_YMw@mail.gmail.com>
	 <1378941761.4714.37.camel@joe-AO722>
	 <201309120840.HHE37542.OJMFFHSOQOtVFL@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 08:40 +0900, Tetsuo Handa wrote:
> Joe Perches wrote:
> > -	seq_printf(m, "%s%d%n", con->name, con->index, &len);
> > +	len = seq_printf(m, "%s%d", con->name, con->index);
> 
> Isn't len always 0 or -1 ?

Right.  Well you're no fun...

These uses would seem broken anyway because the
seq_printf isn't itself tested for correctness.

Hmm.

Also, there's a large amount of code that appears
to do calculations with pos or len like:

	pos += seq_printf(handle, fmt. ...)

There are very few that seem to use it correctly
like netfilter.

$ grep -rP --include=*.[ch] "^[ \t]*\S[ \t\S]*\bseq_[v]?printf\b" *

Suggestions?

> int seq_vprintf(struct seq_file *m, const char *f, va_list args)
> {
> 	int len;
> 
> 	if (m->count < m->size) {
> 		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
> 		if (m->count + len < m->size) {
> 			m->count += len;
> 			return 0;
> 		}
> 	}
> 	seq_set_overflow(m);
> 	return -1;
> }
> EXPORT_SYMBOL(seq_vprintf);
> 
> int seq_printf(struct seq_file *m, const char *f, ...)
> {
> 	int ret;
> 	va_list args;
> 
> 	va_start(args, f);
> 	ret = seq_vprintf(m, f, args);
> 	va_end(args);
> 
> 	return ret;
> }
> EXPORT_SYMBOL(seq_printf);


