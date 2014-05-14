Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaENQUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:20:55 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:58006 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbaENQUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:20:54 -0400
Date: Wed, 14 May 2014 11:20:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
In-Reply-To: <6eafe1e95d9a934228e9af785f5b5de38955aa6a.1399982635.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405141119320.16512@gentwo.org>
References: <cover.1399982635.git.vdavydov@parallels.com> <6eafe1e95d9a934228e9af785f5b5de38955aa6a.1399982635.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Vladimir Davydov wrote:

> Since the "slow" and the "normal" free's can't coexist at the same time,
> we must assure all conventional free's have finished before switching
> all further free's to the "slow" mode and starting reparenting. To
> achieve that, a percpu refcounter is used. It is taken and held during
> each "normal" free. The refcounter is killed on memcg offline, and the
> cache's pages migration is initiated from the refcounter's release
> function. If we fail to take a ref on kfree, it means all "normal"
> free's have been completed and the cache is being reparented right now,
> so we should free the object using the "slow" mode.

Argh adding more code to the free path touching more cachelines in the
process.

