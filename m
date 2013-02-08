Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945928Ab3BHBxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:53:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113Ab3BHBxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:53:00 -0500
Date: Thu, 7 Feb 2013 23:45:34 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: Re: [PATCH v12 rebased 1/8] preserve cpu runstate
Message-ID: <20130208014533.GB3364@amt.cnet>
References: <cover.1358920534.git.hutao@cn.fujitsu.com>
 <40805800eed9ed08f44b088e8a50f71c69e6cac4.1358920534.git.hutao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40805800eed9ed08f44b088e8a50f71c69e6cac4.1358920534.git.hutao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 03:19:22PM +0800, Hu Tao wrote:
> This patch enables preservation of cpu runstate during save/load vm.
> So when a vm is restored from snapshot, the cpu runstate is restored,
> too.
> 
> See following example:
> 
> # save two vms: one is running, the other is paused
> (qemu) info status
> VM status: running
> (qemu) savevm running
> (qemu) stop
> (qemu) info status
> VM status: paused
> (qemu) savevm paused
> 
> # restore the one running
> (qemu) info status
> VM status: paused
> (qemu) loadvm running
> (qemu) info status
> VM status: running
> 
> # restore the one paused
> (qemu) loadvm paused
> (qemu) info status
> VM status: paused
> (qemu) cont
> (qemu)info status
> VM status: running
> 
> 
> Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>

Lack of pause state on guest images is annoying. 

Fail to see why the panic feature depends on preservation of cpu
runstate.

>  include/sysemu/sysemu.h |  2 ++
>  migration.c             |  6 +-----
>  monitor.c               |  5 ++---
>  savevm.c                |  1 +
>  vl.c                    | 34 ++++++++++++++++++++++++++++++++++
>  5 files changed, 40 insertions(+), 8 deletions(-)
> 
> diff --git a/include/sysemu/sysemu.h b/include/sysemu/sysemu.h
> index 337ce7d..7a69fde 100644
> --- a/include/sysemu/sysemu.h
> +++ b/include/sysemu/sysemu.h
> @@ -19,6 +19,8 @@ extern uint8_t qemu_uuid[];
>  int qemu_uuid_parse(const char *str, uint8_t *uuid);
>  #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx"
>  
> +void save_run_state(void);
> +void load_run_state(void);
>  bool runstate_check(RunState state);
>  void runstate_set(RunState new_state);
>  int runstate_is_running(void);
> diff --git a/migration.c b/migration.c
> index 77c1971..f96cfd6 100644
> --- a/migration.c
> +++ b/migration.c
> @@ -108,11 +108,7 @@ static void process_incoming_migration_co(void *opaque)
>      /* Make sure all file formats flush their mutable metadata */
>      bdrv_invalidate_cache_all();
>  
> -    if (autostart) {
> -        vm_start();
> -    } else {
> -        runstate_set(RUN_STATE_PAUSED);
> -    }
> +    load_run_state();
>  }
>  
>  static void enter_migration_coroutine(void *opaque)
> diff --git a/monitor.c b/monitor.c
> index 20bd19b..9381ed0 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -2059,13 +2059,12 @@ void qmp_closefd(const char *fdname, Error **errp)
>  
>  static void do_loadvm(Monitor *mon, const QDict *qdict)
>  {
> -    int saved_vm_running  = runstate_is_running();
>      const char *name = qdict_get_str(qdict, "name");
>  
>      vm_stop(RUN_STATE_RESTORE_VM);
>  
> -    if (load_vmstate(name) == 0 && saved_vm_running) {
> -        vm_start();
> +    if (load_vmstate(name) == 0) {
> +        load_run_state();
>      }
>  }
>  
> diff --git a/savevm.c b/savevm.c
> index 304d1ef..10f1d56 100644
> --- a/savevm.c
> +++ b/savevm.c
> @@ -2112,6 +2112,7 @@ void do_savevm(Monitor *mon, const QDict *qdict)
>      }
>  
>      saved_vm_running = runstate_is_running();
> +    save_run_state();
>      vm_stop(RUN_STATE_SAVE_VM);
>  
>      memset(sn, 0, sizeof(*sn));
> diff --git a/vl.c b/vl.c
> index 4ee1302..b0bcf1e 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -520,6 +520,7 @@ static int default_driver_check(QemuOpts *opts, void *opaque)
>  /* QEMU state */
>  
>  static RunState current_run_state = RUN_STATE_PRELAUNCH;
> +static RunState saved_run_state = RUN_STATE_PRELAUNCH;
>  
>  typedef struct {
>      RunState from;
> @@ -543,6 +544,7 @@ static const RunStateTransition runstate_transitions_def[] = {
>      { RUN_STATE_PAUSED, RUN_STATE_FINISH_MIGRATE },
>  
>      { RUN_STATE_POSTMIGRATE, RUN_STATE_RUNNING },
> +    { RUN_STATE_POSTMIGRATE, RUN_STATE_PAUSED },
>      { RUN_STATE_POSTMIGRATE, RUN_STATE_FINISH_MIGRATE },
>  
>      { RUN_STATE_PRELAUNCH, RUN_STATE_RUNNING },
> @@ -553,6 +555,7 @@ static const RunStateTransition runstate_transitions_def[] = {
>      { RUN_STATE_FINISH_MIGRATE, RUN_STATE_POSTMIGRATE },
>  
>      { RUN_STATE_RESTORE_VM, RUN_STATE_RUNNING },
> +    { RUN_STATE_RESTORE_VM, RUN_STATE_PAUSED },
>  
>      { RUN_STATE_RUNNING, RUN_STATE_DEBUG },
>      { RUN_STATE_RUNNING, RUN_STATE_INTERNAL_ERROR },
> @@ -582,11 +585,39 @@ static const RunStateTransition runstate_transitions_def[] = {
>  
>  static bool runstate_valid_transitions[RUN_STATE_MAX][RUN_STATE_MAX];
>  
> +void save_run_state(void)
> +{
> +    saved_run_state = current_run_state;
> +}
> +
> +void load_run_state(void)
> +{
> +    if (saved_run_state == RUN_STATE_RUNNING) {
> +        vm_start();
> +    } else if (!runstate_check(saved_run_state)) {
> +        runstate_set(saved_run_state);
> +    } else {
> +        ; /* leave unchanged */
> +    }
> +}
> +
>  bool runstate_check(RunState state)
>  {
>      return current_run_state == state;
>  }
>  
> +static void runstate_save(QEMUFile *f, void *opaque)
> +{
> +    qemu_put_byte(f, saved_run_state);
> +}
> +
> +static int runstate_load(QEMUFile *f, void *opaque, int version_id)
> +{
> +    saved_run_state = qemu_get_byte(f);
> +
> +    return 0;
> +}

This breaks loading images without support for runstate information. 
Is it possible to overcome this limitation?

Would be happier if this patch could be debated on QEMU list.

