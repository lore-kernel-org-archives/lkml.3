Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab3BTINo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:13:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49739 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab3BTINn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:13:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,700,1355068800"; 
   d="scan'208";a="6735163"
Date: Wed, 20 Feb 2013 16:13:49 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v12 rebased 2/8] start vm after resetting it
Message-ID: <20130220081348.GC23246@localhost.localdomain>
References: <cover.1358920534.git.hutao@cn.fujitsu.com>
 <19fae3171e31ae90c208895d90ad912291936794.1358920534.git.hutao@cn.fujitsu.com>
 <20130208015028.GC3364@amt.cnet>
MIME-Version: 1.0
In-Reply-To: <20130208015028.GC3364@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 16:13:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 16:13:01,
	Serialize complete at 2013/02/20 16:13:01
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 11:50:28PM -0200, Marcelo Tosatti wrote:
> On Wed, Jan 23, 2013 at 03:19:23PM +0800, Hu Tao wrote:
> > From: Wen Congyang <wency@cn.fujitsu.com>
> > 
> > The guest should run after resetting it, but it does not run if its
> > old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.
> > 
> > We don't set runstate to RUN_STATE_PAUSED when resetting the guest,
> > so the runstate will be changed from RUN_STATE_INTERNAL_ERROR or
> > RUN_STATE_PAUSED to RUN_STATE_RUNNING(not RUN_STATE_PAUSED).
> 
> It appears the last hunk will automatically reset state from 
> RUN_STATE_INTERNAL_ERROR to RUN_STATE_RUNNING ?

Yes.

> 
> I suppose the transition table allows, from RUN_STATE_INTERNAL_ERROR:
> 
> <monitor> system_reset
> <monitor> cont
> 
> To resume the machine?

True.

I think the purpose of this patch is to always reset and _run_ the guest
by `system_reset', avoiding an additional `cont' following `system_reset'.

> 
> > 
> > Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> > ---
> >  include/block/block.h | 2 ++
> >  qmp.c                 | 2 +-
> >  vl.c                  | 7 ++++---
> >  3 files changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/block/block.h b/include/block/block.h
> > index ffd1936..5e82ccb 100644
> > --- a/include/block/block.h
> > +++ b/include/block/block.h
> > @@ -366,6 +366,8 @@ void bdrv_disable_copy_on_read(BlockDriverState *bs);
> >  void bdrv_set_in_use(BlockDriverState *bs, int in_use);
> >  int bdrv_in_use(BlockDriverState *bs);
> >  
> > +void iostatus_bdrv_it(void *opaque, BlockDriverState *bs);
> > +
> >  #ifdef CONFIG_LINUX_AIO
> >  int raw_get_aio_fd(BlockDriverState *bs);
> >  #else
> > diff --git a/qmp.c b/qmp.c
> > index 55b056b..5f1bed1 100644
> > --- a/qmp.c
> > +++ b/qmp.c
> > @@ -130,7 +130,7 @@ SpiceInfo *qmp_query_spice(Error **errp)
> >  };
> >  #endif
> >  
> > -static void iostatus_bdrv_it(void *opaque, BlockDriverState *bs)
> > +void iostatus_bdrv_it(void *opaque, BlockDriverState *bs)
> >  {
> >      bdrv_iostatus_reset(bs);
> >  }
> > diff --git a/vl.c b/vl.c
> > index b0bcf1e..1d2edaa 100644
> > --- a/vl.c
> > +++ b/vl.c
> > @@ -534,7 +534,7 @@ static const RunStateTransition runstate_transitions_def[] = {
> >      { RUN_STATE_INMIGRATE, RUN_STATE_RUNNING },
> >      { RUN_STATE_INMIGRATE, RUN_STATE_PAUSED },
> >  
> > -    { RUN_STATE_INTERNAL_ERROR, RUN_STATE_PAUSED },
> > +    { RUN_STATE_INTERNAL_ERROR, RUN_STATE_RUNNING },
> >      { RUN_STATE_INTERNAL_ERROR, RUN_STATE_FINISH_MIGRATE },
> >  
> >      { RUN_STATE_IO_ERROR, RUN_STATE_RUNNING },
> > @@ -569,7 +569,7 @@ static const RunStateTransition runstate_transitions_def[] = {
> >  
> >      { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
> >  
> > -    { RUN_STATE_SHUTDOWN, RUN_STATE_PAUSED },
> > +    { RUN_STATE_SHUTDOWN, RUN_STATE_RUNNING },
> >      { RUN_STATE_SHUTDOWN, RUN_STATE_FINISH_MIGRATE },
> >  
> >      { RUN_STATE_DEBUG, RUN_STATE_SUSPENDED },
> > @@ -1951,7 +1951,8 @@ static bool main_loop_should_exit(void)
> >          resume_all_vcpus();
> >          if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
> >              runstate_check(RUN_STATE_SHUTDOWN)) {
> > -            runstate_set(RUN_STATE_PAUSED);
> > +            bdrv_iterate(iostatus_bdrv_it, NULL);
> > +            vm_start();
> >          }
> >      }
> >      if (qemu_wakeup_requested()) {
> > -- 
> > 1.8.0.1.240.ge8a1f5a
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards,
Hu Tao
