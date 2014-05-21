Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaEUOp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:45:58 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:59296 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbaEUOp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:45:57 -0400
Date: Wed, 21 May 2014 09:45:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
In-Reply-To: <20140521135826.GA23193@esperanza>
Message-ID: <alpine.DEB.2.10.1405210944140.8038@gentwo.org>
References: <cover.1399982635.git.vdavydov@parallels.com> <6eafe1e95d9a934228e9af785f5b5de38955aa6a.1399982635.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405141119320.16512@gentwo.org> <20140515071650.GB32113@esperanza> <alpine.DEB.2.10.1405151015330.24665@gentwo.org>
 <20140516132234.GF32113@esperanza> <alpine.DEB.2.10.1405160957100.32249@gentwo.org> <20140519152437.GB25889@esperanza> <alpine.DEB.2.10.1405191056580.22956@gentwo.org> <537A4D27.1050909@parallels.com> <20140521135826.GA23193@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, Vladimir Davydov wrote:

> Seems I've found a better way to avoid this race, which does not involve
> messing up free hot paths. The idea is to explicitly zap each per-cpu
> partial list by setting it pointing to an invalid ptr. Since
> put_cpu_partial(), which is called from __slab_free(), uses atomic
> cmpxchg for adding a new partial slab to a per cpu partial list, it is
> enough to add a check if partials are zapped there and bail out if so.
>
> The patch doing the trick is attached. Could you please take a look at
> it once time permit?

Well if you set s->cpu_partial = 0 then the slab should not be added to
the partial lists. Ok its put on there temporarily but then immediately
moved to the node partial list in put_cpu_partial().

