Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3GBQsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:48:20 -0400
Received: from cobra.newdream.net ([66.33.216.30]:51213 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3GBQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:48:18 -0400
Date: Tue, 2 Jul 2013 09:48:18 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: majianpeng <majianpeng@gmail.com>
cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mds: update atime if client can read.
In-Reply-To: <201307021345090019137@gmail.com>
Message-ID: <alpine.DEB.2.00.1307020946520.1067@cobra.newdream.net>
References: <201307021345090019137@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013, majianpeng wrote:
> Now, update atime only for CEPH_CAP_FILE_EXCL.Change this if
> CEPH_CAP_FILE_RD.

Can we introduce a global config optoin (bool mds_atime in 
common/config_opts.h, maybe) so that users can turn this off?  And/or add 
a 'relatime' option?  More users won't want this as it is very expensive 
to maintain this extra level of metadata.

That aside, this approach looks right to me. :)

Thanks!
sage


 > 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  src/mds/Locker.cc | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/src/mds/Locker.cc b/src/mds/Locker.cc
> index 30e014a..58f953f 100644
> --- a/src/mds/Locker.cc
> +++ b/src/mds/Locker.cc
> @@ -2676,8 +2676,9 @@ void Locker::_do_snap_update(CInode *in, snapid_t snap, int dirty, snapid_t foll
>  void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *pi)
>  {
>    // file
> +  utime_t atime = m->get_atime();
> +
>    if (dirty & (CEPH_CAP_FILE_EXCL|CEPH_CAP_FILE_WR)) {
> -    utime_t atime = m->get_atime();
>      utime_t mtime = m->get_mtime();
>      utime_t ctime = m->get_ctime();
>      uint64_t size = m->get_size();
> @@ -2700,11 +2701,7 @@ void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *
>        pi->size = size;
>        pi->rstat.rbytes = size;
>      }
> -    if ((dirty & CEPH_CAP_FILE_EXCL) && atime != pi->atime) {
> -      dout(7) << "  atime " << pi->atime << " -> " << atime
> -	      << " for " << *in << dendl;
> -      pi->atime = atime;
> -    }
> +    
>      if ((dirty & CEPH_CAP_FILE_EXCL) &&
>  	ceph_seq_cmp(pi->time_warp_seq, m->get_time_warp_seq()) < 0) {
>        dout(7) << "  time_warp_seq " << pi->time_warp_seq << " -> " << m->get_time_warp_seq()
> @@ -2712,6 +2709,12 @@ void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *
>        pi->time_warp_seq = m->get_time_warp_seq();
>      }
>    }
> +  
> +  if ((dirty & CEPH_CAP_FILE_RD) && atime > pi->atime) {
> +      dout(7) << "  atime " << pi->atime << " -> " << atime
> +	      << " for " << *in << dendl;
> +      pi->atime = atime;
> +  }
>    // auth
>    if (dirty & CEPH_CAP_AUTH_EXCL) {
>      if (m->head.uid != pi->uid) {
> -- 
> 1.8.3.rc1.44.gb387c77
> 
