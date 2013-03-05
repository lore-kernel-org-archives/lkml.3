Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab3CECdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:33:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53430 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab3CECdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:33:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,784,1355068800"; 
   d="scan'208";a="6812088"
Date: Tue, 5 Mar 2013 10:33:08 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 1/8] save/load cpu runstate
Message-ID: <20130305023308.GK16362@localhost.localdomain>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <df20999140db716e8b1ccd57a7cbcb0fa343a78c.1362051582.git.hutao@cn.fujitsu.com>
 <513469C8.30602@redhat.com>
MIME-Version: 1.0
In-Reply-To: <513469C8.30602@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 10:31:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 10:32:00,
	Serialize complete at 2013/03/05 10:32:00
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:30:48AM +0100, Paolo Bonzini wrote:
> Il 28/02/2013 13:13, Hu Tao ha scritto:
> > This patch enables preservation of cpu runstate during save/load vm.
> > So when a vm is restored from snapshot, the cpu runstate is restored,
> > too.
> 
> I don't think this feature is worth breaking backwards migration
> compatibility.  It is usually handled at a higher-level (management,
> like libvirt).

If guest panic happens during migration, runstate will still be running
on destination host without this patch. But, it does be a problem to break
backwards migration compatibility.

> 
> Please make this a separate patch.

Sure.

> 
> Paolo
> 
> > See following example:
> > 
> > # save two vms: one is running, the other is paused
> > (qemu) info status
> > VM status: running
> > (qemu) savevm running
> > (qemu) stop
> > (qemu) info status
> > VM status: paused
> > (qemu) savevm paused
> > 
> > # restore the one running
> > (qemu) info status
> > VM status: paused
> > (qemu) loadvm running
> > (qemu) info status
> > VM status: running
> > 
> > # restore the one paused
> > (qemu) loadvm paused
> > (qemu) info status
> > VM status: paused
> > (qemu) cont
> > (qemu)info status
> > VM status: running
> > 
> > Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
> > ---
> >  include/sysemu/sysemu.h |  2 ++
> >  migration.c             |  6 +-----
> >  monitor.c               |  5 ++---
> >  savevm.c                |  1 +
> >  vl.c                    | 34 ++++++++++++++++++++++++++++++++++
> >  5 files changed, 40 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/sysemu/sysemu.h b/include/sysemu/sysemu.h
> > index b19ec95..f121213 100644
> > --- a/include/sysemu/sysemu.h
> > +++ b/include/sysemu/sysemu.h
> > @@ -19,6 +19,8 @@ extern uint8_t qemu_uuid[];
> >  int qemu_uuid_parse(const char *str, uint8_t *uuid);
> >  #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx"
> >  
> > +void save_run_state(void);
> > +void load_run_state(void);
> >  bool runstate_check(RunState state);
> >  void runstate_set(RunState new_state);
> >  int runstate_is_running(void);
> > diff --git a/migration.c b/migration.c
> > index 11725ae..c29830e 100644
> > --- a/migration.c
> > +++ b/migration.c
> > @@ -107,11 +107,7 @@ static void process_incoming_migration_co(void *opaque)
> >      /* Make sure all file formats flush their mutable metadata */
> >      bdrv_invalidate_cache_all();
> >  
> > -    if (autostart) {
> > -        vm_start();
> > -    } else {
> > -        runstate_set(RUN_STATE_PAUSED);
> > -    }
> > +    load_run_state();
> >  }
> >  
> >  void process_incoming_migration(QEMUFile *f)
> > diff --git a/monitor.c b/monitor.c
> > index 32a6e74..bf974b4 100644
> > --- a/monitor.c
> > +++ b/monitor.c
> > @@ -2059,13 +2059,12 @@ void qmp_closefd(const char *fdname, Error **errp)
> >  
> >  static void do_loadvm(Monitor *mon, const QDict *qdict)
> >  {
> > -    int saved_vm_running  = runstate_is_running();
> >      const char *name = qdict_get_str(qdict, "name");
> >  
> >      vm_stop(RUN_STATE_RESTORE_VM);
> >  
> > -    if (load_vmstate(name) == 0 && saved_vm_running) {
> > -        vm_start();
> > +    if (load_vmstate(name) == 0) {
> > +        load_run_state();
> >      }
> >  }
> >  
> > diff --git a/savevm.c b/savevm.c
> > index a8a53ef..aa631eb 100644
> > --- a/savevm.c
> > +++ b/savevm.c
> > @@ -2143,6 +2143,7 @@ void do_savevm(Monitor *mon, const QDict *qdict)
> >      }
> >  
> >      saved_vm_running = runstate_is_running();
> > +    save_run_state();
> >      vm_stop(RUN_STATE_SAVE_VM);
> >  
> >      memset(sn, 0, sizeof(*sn));
> > diff --git a/vl.c b/vl.c
> > index febd2ea..7991f2e 100644
> > --- a/vl.c
> > +++ b/vl.c
> > @@ -523,6 +523,7 @@ static int default_driver_check(QemuOpts *opts, void *opaque)
> >  /* QEMU state */
> >  
> >  static RunState current_run_state = RUN_STATE_PRELAUNCH;
> > +static RunState saved_run_state = RUN_STATE_RUNNING;
> >  
> >  typedef struct {
> >      RunState from;
> > @@ -546,6 +547,7 @@ static const RunStateTransition runstate_transitions_def[] = {
> >      { RUN_STATE_PAUSED, RUN_STATE_FINISH_MIGRATE },
> >  
> >      { RUN_STATE_POSTMIGRATE, RUN_STATE_RUNNING },
> > +    { RUN_STATE_POSTMIGRATE, RUN_STATE_PAUSED },
> >      { RUN_STATE_POSTMIGRATE, RUN_STATE_FINISH_MIGRATE },
> >  
> >      { RUN_STATE_PRELAUNCH, RUN_STATE_RUNNING },
> > @@ -556,6 +558,7 @@ static const RunStateTransition runstate_transitions_def[] = {
> >      { RUN_STATE_FINISH_MIGRATE, RUN_STATE_POSTMIGRATE },
> >  
> >      { RUN_STATE_RESTORE_VM, RUN_STATE_RUNNING },
> > +    { RUN_STATE_RESTORE_VM, RUN_STATE_PAUSED },
> >  
> >      { RUN_STATE_RUNNING, RUN_STATE_DEBUG },
> >      { RUN_STATE_RUNNING, RUN_STATE_INTERNAL_ERROR },
> > @@ -585,11 +588,39 @@ static const RunStateTransition runstate_transitions_def[] = {
> >  
> >  static bool runstate_valid_transitions[RUN_STATE_MAX][RUN_STATE_MAX];
> >  
> > +void save_run_state(void)
> > +{
> > +    saved_run_state = current_run_state;
> > +}
> > +
> > +void load_run_state(void)
> > +{
> > +    if (saved_run_state == RUN_STATE_RUNNING) {
> > +        vm_start();
> > +    } else if (!runstate_check(saved_run_state)) {
> > +        runstate_set(saved_run_state);
> > +    } else {
> > +        ; /* leave unchanged */
> > +    }
> > +}
> > +
> >  bool runstate_check(RunState state)
> >  {
> >      return current_run_state == state;
> >  }
> >  
> > +static void runstate_save(QEMUFile *f, void *opaque)
> > +{
> > +    qemu_put_byte(f, saved_run_state);
> > +}
> > +
> > +static int runstate_load(QEMUFile *f, void *opaque, int version_id)
> > +{
> > +    saved_run_state = qemu_get_byte(f);
> > +
> > +    return 0;
> > +}
> > +
> >  static void runstate_init(void)
> >  {
> >      const RunStateTransition *p;
> > @@ -599,6 +630,9 @@ static void runstate_init(void)
> >      for (p = &runstate_transitions_def[0]; p->from != RUN_STATE_MAX; p++) {
> >          runstate_valid_transitions[p->from][p->to] = true;
> >      }
> > +
> > +    register_savevm(NULL, "runstate", 0, 1,
> > +                    runstate_save, runstate_load, NULL);
> >  }
> >  
> >  /* This function will abort() on invalid state transitions */
> > 
