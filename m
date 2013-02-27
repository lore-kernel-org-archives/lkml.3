Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323Ab3B0Ske (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:40:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab3B0Skc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:40:32 -0500
Date: Wed, 27 Feb 2013 19:38:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-api@vger.kernel.org,
        Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH 1/2] ptrace: add ability to retrieve signals without
	removing from a queue (v3)
Message-ID: <20130227183850.GA6042@redhat.com>
References: <1361975829-1738-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361975829-1738-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Andrey Vagin wrote:
>
> +struct ptrace_peeksiginfo_args {
> +	__u64 off;	/* from which siginfo to start */

Cough... You are optimist. You want to handle the case when the
tracee has 1 << 33 or more pending sigqueues. OK good luck ;)

Looks correct, just one nit.

> +	for (i = 0; i < arg.nr; i++) {
> ...
> +		data += sizeof(siginfo_t);
> +
> +		if (signal_pending(current)) {
> +			i++; /* accounting the current siginfo */
> +			break;
> +		}

Imho, this is confusing. Just do

	for (i = 0; i < arg.nr; ) {
		...

		data += sizeof(siginfo_t);
		i++;

		if (signal_pending(current))
			break;

Oleg.

