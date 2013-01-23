Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab3AWQHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:07:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab3AWQHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:07:13 -0500
Date: Wed, 23 Jan 2013 14:07:00 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>, airlied@linux.ie,
        deathsimple@vodafone.de, jglisse@redhat.com, airlied@redhat.com,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] drm/radeon: fix NULL pointer dereference in UMS mode in
 radeon_cs_parser_fini()
Message-ID: <20130123160659.GC15627@herton-Z68MA-D2H-B3>
References: <1358379788.7243.10.camel@lorien2>
 <Pine.GSO.4.64.1301162045321.898@umail>
 <1358442582.2828.11.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358442582.2828.11.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:09:42AM -0700, Shuah Khan wrote:
> On Wed, 2013-01-16 at 21:06 -0600, Ilija Hadzic wrote:
> > Actually, the code path affected by your patch is not executed in UMS mode 
> > at all. Notice that radeon_cs_parser_fini is only called from 
> > radeon_cs_ioctl which is a KMS-only ioctl (see radeon_kms.c).
> > 
> > The equivalent of the fix you are trying to do is in
> > a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e (function patched by that one is 
> > the one used by legacy-CS ioctl), which you should go together 
> > with ff4bd0827764e10a428a9d39e6814c5478863f94 if you are backporting UMS 
> > fixes to 3.7. Both are needed to prevent kernel crashes in UMS mode.
> > 
> > -- Ilija
> 
> Thanks. I will take a look at a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e.
> I sent back-ported ff4bd0827764e10a428a9d39e6814c5478863f94 patch to
> stable and I will back-port and send
> a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e as well.

While at it, also looks like commit
25d8999780f8c1f53928f4a24a09c01550423109 could also be added to stables.
But while looking at it, while the patch itself is correct, I noted that
there is a possibility of double free: if either of the
p->chunks[p->chunk_ib_idx].kpage[] items are non NULL, we will free it in
radeon_cs_parser_init and also when calling one of the fini functions
(radeon_cs_parser_fini or r600_cs_parser_fini). So either we need to set
kpage[n] to NULL after kfree, or just return the error.

> 
> -- Shuah

-- 
[]'s
Herton
