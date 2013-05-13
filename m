Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3EMW5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:57:18 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:37288 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3EMW5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:57:16 -0400
Message-ID: <1368486003.4020.37.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 3/3] target: simplify target_wait_for_sess_cmds()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Date: Mon, 13 May 2013 16:00:03 -0700
In-Reply-To: <1368477007-25274-4-git-send-email-joern@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
	 <1368477007-25274-4-git-send-email-joern@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 16:30 -0400, Joern Engel wrote:
> The second parameter was always 0, leading to effectively dead code.  It
> called list_del() and se_cmd->se_tfo->release_cmd(), and had to set a
> flag to prevent target_release_cmd_kref() from doing the same.

Look again.  The call to transport_wait_for_tasks() was dead code, but
the wait_for_completion(&se_cmd->cmd_wait_comp) most certainly is not.

> But most
> of all, it iterated the list without taking se_sess->sess_cmd_lock,
> leading to races against ABORT and LUN_RESET.
> 

Ugh.  You'll recall that target_wait_for_sess_cmds() originally did not
have to take the lock because the list was spliced into
sess_wait_list.  

When Roland removed sess_wait_list in commit 1c7b13fe, no one re-added
the lock here.

> Since the whole point of the function is to wait for the list to drain,
> and potentially print a bit of debug information in case that never
> happens, I've replaced the wait_for_completion() with 100ms sleep.  The
> only callpath that would get delayed by this is rmmod, afaics, so I
> didn't want the overhead of a waitqueue.
> 

This seems totally wrong..

> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c  |    2 +-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    2 +-
>  drivers/target/target_core_transport.c |   64 +++++++++-----------------------
>  include/target/target_core_base.h      |    2 -
>  include/target/target_core_fabric.h    |    2 +-
>  5 files changed, 20 insertions(+), 52 deletions(-)
> 

<SNIP>

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 0d46276..5b6dbf9 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1043,7 +1043,6 @@ void transport_init_se_cmd(
>  	init_completion(&cmd->transport_lun_fe_stop_comp);
>  	init_completion(&cmd->transport_lun_stop_comp);
>  	init_completion(&cmd->t_transport_stop_comp);
> -	init_completion(&cmd->cmd_wait_comp);
>  	init_completion(&cmd->task_stop_comp);
>  	spin_lock_init(&cmd->t_state_lock);
>  	cmd->transport_state = CMD_T_DEV_ACTIVE;
> @@ -2219,11 +2218,6 @@ static void target_release_cmd_kref(struct kref *kref)
>  		se_cmd->se_tfo->release_cmd(se_cmd);
>  		return;
>  	}
> -	if (se_sess->sess_tearing_down && se_cmd->cmd_wait_set) {
> -		spin_unlock(&se_sess->sess_cmd_lock);
> -		complete(&se_cmd->cmd_wait_comp);
> -		return;
> -	}
>  	list_del(&se_cmd->se_cmd_list);
>  	spin_unlock(&se_sess->sess_cmd_lock);
>  
> @@ -2241,68 +2235,44 @@ int target_put_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd)
>  }
>  EXPORT_SYMBOL(target_put_sess_cmd);
>  
> -/* target_sess_cmd_list_set_waiting - Flag all commands in
> - *         sess_cmd_list to complete cmd_wait_comp.  Set
> +/* target_sess_cmd_list_set_waiting - Set
>   *         sess_tearing_down so no more commands are queued.
>   * @se_sess:	session to flag
>   */
>  void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
>  {
> -	struct se_cmd *se_cmd;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -
>  	WARN_ON(se_sess->sess_tearing_down);
>  	se_sess->sess_tearing_down = 1;
> -
> -	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list)
> -		se_cmd->cmd_wait_set = 1;
> -
>  	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>  }
>  EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
>  
>  /* target_wait_for_sess_cmds - Wait for outstanding descriptors
>   * @se_sess:    session to wait for active I/O
> - * @wait_for_tasks:	Make extra transport_wait_for_tasks call
>   */
> -void target_wait_for_sess_cmds(
> -	struct se_session *se_sess,
> -	int wait_for_tasks)
> +void target_wait_for_sess_cmds(struct se_session *se_sess)
>  {
> -	struct se_cmd *se_cmd, *tmp_cmd;
> -	bool rc = false;
> -
> -	list_for_each_entry_safe(se_cmd, tmp_cmd,
> -				&se_sess->sess_cmd_list, se_cmd_list) {
> -		list_del(&se_cmd->se_cmd_list);
> -
> -		pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state:"
> -			" %d\n", se_cmd, se_cmd->t_state,
> -			se_cmd->se_tfo->get_cmd_state(se_cmd));
> -
> -		if (wait_for_tasks) {
> -			pr_debug("Calling transport_wait_for_tasks se_cmd: %p t_state: %d,"
> -				" fabric state: %d\n", se_cmd, se_cmd->t_state,
> -				se_cmd->se_tfo->get_cmd_state(se_cmd));
> -
> -			rc = transport_wait_for_tasks(se_cmd);
> -
> -			pr_debug("After transport_wait_for_tasks se_cmd: %p t_state: %d,"
> -				" fabric state: %d\n", se_cmd, se_cmd->t_state,
> -				se_cmd->se_tfo->get_cmd_state(se_cmd));
> -		}
> +	struct se_cmd *se_cmd, *last_cmd = NULL;
> +	unsigned long flags;
>  
> -		if (!rc) {
> -			wait_for_completion(&se_cmd->cmd_wait_comp);
> -			pr_debug("After cmd_wait_comp: se_cmd: %p t_state: %d"
> -				" fabric state: %d\n", se_cmd, se_cmd->t_state,
> -				se_cmd->se_tfo->get_cmd_state(se_cmd));
> +	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> +	while (!list_empty(&se_sess->sess_cmd_list)) {
> +		se_cmd = list_entry(se_sess->sess_cmd_list.next, struct se_cmd,
> +			se_cmd_list);
> +		if (se_cmd != last_cmd) { /* print this only once per command */
> +			pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state: %d\n",
> +					se_cmd, se_cmd->t_state,
> +					se_cmd->se_tfo->get_cmd_state(se_cmd));
> +			last_cmd = se_cmd;
>  		}
> -
> -		se_cmd->se_tfo->release_cmd(se_cmd);
> +		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +		msleep_interruptible(100);
> +		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>  	}
> +	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>  }

So what happens when the backend se_cmd I/O does not complete before the
msleep finishes..?

It seems totally wrong to drop the initial cmd_wait_set =1 assignment,
target_release_cmd_kref() completion for cmd_wait_comp, and wait on
cmd_wait_comp to allow se_cmd to finish processing here.

Who cares about waitqueue overhead in a shutdown slow path when the
replacement doesn't address long outstanding commands..?

--nab

