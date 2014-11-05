Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaKELKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:10:50 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33194 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaKELKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:10:48 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: gong.chen@linux.intel.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        " Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel@stlinux.com, eric.paire@st.com
Subject: Re: [PATCH v3] bitops: Fix shift overflow in GENMASK macros
Organization: D03
References: <1415098697-16304-1-git-send-email-maxime.coquelin@st.com>
X-Hashcash: 1:20:141105:stable@vger.kernel.org::WTGLoEeqECdzbX2Z:0000000000000000000000000000000000000000LSN
X-Hashcash: 1:20:141105:mingo@kernel.org::UofCtWbqbnxy3Q7o:00TLN
X-Hashcash: 1:20:141105:maxime.coquelin@st.com::8mLk70n7xpWCCiIo:00000000000000000000000000000000000000005QV
X-Hashcash: 1:20:141105:peterz@infradead.org::Yy4+btWyIRCUHhaX:000000000000000000000000000000000000000001zs4
X-Hashcash: 1:20:141105:tytso@mit.edu::DfqCJ/Ho4jB8FiFI:00005cso
X-Hashcash: 1:20:141105:gong.chen@linux.intel.com::XqXWrs3yrTFVvUBB:0000000000000000000000000000000000007mTu
X-Hashcash: 1:20:141105:paulmck@linux.vnet.ibm.com::wBdJOBeLW8VQ7LEl:000000000000000000000000000000000007ZRC
X-Hashcash: 1:20:141105:linux-kernel@vger.kernel.org::5D2F8nzCHI9x0qpz:00000000000000000000000000000000080ie
X-Hashcash: 1:20:141105:kernel@stlinux.com::mwtL3/1fXC40JF/W:00000000000000000000000000000000000000000008uPe
X-Hashcash: 1:20:141105:eric.paire@st.com::NOYFUsDn2PkIpdEJ:00000000000000000000000000000000000000000000COvG
Date: Wed, 05 Nov 2014 12:10:45 +0100
In-Reply-To: <1415098697-16304-1-git-send-email-maxime.coquelin@st.com>
	(Maxime COQUELIN's message of "Tue, 4 Nov 2014 11:58:17 +0100")
Message-ID: <87vbmt52dm.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04 2014, Maxime COQUELIN <maxime.coquelin@st.com> wrote:

> -#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
> -#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
> +#define GENMASK(h, l) \
> +	((~0UL >> (BITS_PER_LONG - ((h) - (l) + 1))) << (l))
> +
> +#define GENMASK_ULL(h, l) \
> +	((~0ULL >> (BITS_PER_LONG_LONG - ((h) - (l) + 1))) << (l))

Slightly bikeshedding here, but may I suggest spelling it

  (((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))

? This will ensure the arguments are expanded once each, and will, IMHO,
DTRT if/when l > h (namely, yield 0).

Rasmus
