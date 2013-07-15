Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab3GOWI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:08:57 -0400
Received: from longford.logfs.org ([213.229.74.203]:59811 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3GOWIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:08:55 -0400
Date: Mon, 15 Jul 2013 16:37:30 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: vaughan <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] [SCSI] sg: fix race condition when do exclusive
 open
Message-ID: <20130715203730.GA21804@logfs.org>
References: <51AF0269.9070900@oracle.com>
 <20130605132746.GA1690@logfs.org>
 <51AF646D.7030903@oracle.com>
 <20130605154106.GA2737@logfs.org>
 <51BF0ADD.1080604@oracle.com>
 <20130705173953.GA15089@logfs.org>
 <51D852DC.4070808@oracle.com>
 <51D9C74D.6060708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51D9C74D.6060708@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 July 2013 03:53:49 +0800, vaughan wrote:
> 
> Use rwsem to aid opens. Exclusive open has to get write lock and non-exclusive open should get read lock.
> Replace global sg_open_exclusive_lock with a per device lock - sfd_lock. Since sfds list is now protected by the lock owned by the same sg_device, sg_index_lock becomes a real global lock to only protect sg devices lookup.
> 
> Please pay attention to sdp->detached. Previously sg_open may also race with sg_remove. Now there are two points for sg_open to detect detached and finish itself. One is at sg_device lookup and the other is when trying to link new sfp into the sfds list in sg_add_sfp.
> I don't think it's necessary to do extra set_exclude and wake_up o_excl_wait in sg_release before, so I remove them and only do the cleanup in sg_remove_sfp.
> Although simple testcases are passed, I'm not certain if I've fixed it well, please give me any comments as you wish.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/scsi/sg.c | 187 ++++++++++++++++++++++++++----------------------------
>  1 file changed, 89 insertions(+), 98 deletions(-)

Had a quick read and I think I like the code.  What I still dislike is
that it merges several independent functional changes into one patch.

Can you create three patches, one for the rwsem part, one for pushing
the locking down to per-device locking and one for the rest?  That
would make it easier for me to understand and trust the individual
patches and for James/Linus to revert one, if it turns out to be bad.

Jörn

--
There are two ways of constructing a software design: one way is to make
it so simple that there are obviously no deficiencies, and the other is
to make it so complicated that there are no obvious deficiencies.
-- C. A. R. Hoare
