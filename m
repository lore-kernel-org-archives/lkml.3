Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3IKXpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:45:46 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56534 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3IKXpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:45:45 -0400
X-Nat-Received: from [202.181.97.72]:61160 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378942855.5216
To: joe@perches.com, linux-kernel@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, keescook@chromium.org, fweisbec@gmail.com,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, tushar.behera@linaro.org,
        lidza.louina@gmail.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        courmisch@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [RFC PATCH] vsnprintf: Remove use of %n and convert existing uses
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1378926562.4714.11.camel@joe-AO722>
	<CAGXu5jLO6109fkejXqX=WhkQnfAUeWtTcow0v1BNqyi=8=Qa3Q@mail.gmail.com>
	<1378928700.4714.17.camel@joe-AO722>
	<CAGXu5jLTjrPr=GwOmMcu55Qp9K-_XS75xq9NJ0vBUEwy-i_YMw@mail.gmail.com>
	<1378941761.4714.37.camel@joe-AO722>
In-Reply-To: <1378941761.4714.37.camel@joe-AO722>
Message-Id: <201309120840.HHE37542.OJMFFHSOQOtVFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 12 Sep 2013 08:40:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11092013 #11039388, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> -	seq_printf(m, "%s%d%n", con->name, con->index, &len);
> +	len = seq_printf(m, "%s%d", con->name, con->index);

Isn't len always 0 or -1 ?

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
