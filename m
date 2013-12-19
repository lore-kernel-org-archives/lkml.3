Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3LSAi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:38:28 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:10957 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3LSAi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:38:26 -0500
Message-ID: <1387413504.2797.36.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
From: Davidlohr Bueso <davidlohr@hp.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Greg Thelen <gthelen@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Date: Wed, 18 Dec 2013 16:38:24 -0800
In-Reply-To: <1fb23e4caf59656e428b27dcc0885ea4be9b76d9.1387398458.git.aquini@redhat.com>
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
	 <1fb23e4caf59656e428b27dcc0885ea4be9b76d9.1387398458.git.aquini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 18:33 -0200, Rafael Aquini wrote:
> After the locking semantics for the SysV IPC API got improved, a couple of
> IPC_RMID race windows were opened because we ended up dropping the
> 'kern_ipc_perm.deleted' check performed way down in ipc_lock().
> The spotted races got sorted out by re-introducing the old test within
> the racy critical sections.
> 
> This patch introduces ipc_valid_object() to consolidate the way we cope with
> IPC_RMID races by using the same abstraction across the API implementation.
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Greg Thelen <gthelen@google.com>

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

[...]

> +/*
> + * ipc_valid_object() - helper to sort out IPC_RMID races for codepaths
> + * where the respective ipc_ids.rwsem is not being held down.
> + * Checks whether the ipc object is still around or if it's gone already, as
> + * ipc_rmid() may have already freed the ID while the ipc lock was spinning.
> + * Needs to be called with kern_ipc_perm.lock held -- exception made for one
> + * checkpoint case at sys_semtimedop() as noted in code commentary.
> + */
> +static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
> +{
> +	return perm->deleted == 0;
> +}

I would like to see .deleted being converted to bool while we're at it
though, that return statement just bugs the hell out of me. Could you
send a patch for that as well?

Thanks,
Davidlohr

