Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab3CSBwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:52:39 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64859 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3CSBwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:52:38 -0400
Date: Mon, 18 Mar 2013 18:53:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH v3] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race
Message-ID: <20130319015354.GA21045@kroah.com>
References: <20130318222853.GA9358@logfs.org>
 <20130319000411.GA6406@kroah.com>
 <20130318225657.GA9685@logfs.org>
 <20130319002742.GA11050@kroah.com>
 <20130318231154.GC9685@logfs.org>
 <20130318233413.GD9685@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130318233413.GD9685@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 07:34:13PM -0400, Jörn Engel wrote:
> And because I'm lame and stupid, here's v3.
> 
> It is possible for one thread to to take se_sess->sess_cmd_lock in
> core_tmr_abort_task() before taking a reference count on
> se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
> se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.
> 
> This introduces kref_put_and_lock() and uses it in
> target_put_sess_cmd() to close the race window.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  drivers/target/target_core_transport.c |   17 +++++++++++------
>  include/linux/kref.h                   |   26 ++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 04ec9cb..b98c158 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2207,21 +2207,19 @@ static void target_release_cmd_kref(struct kref *kref)
>  {
>  	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
>  	struct se_session *se_sess = se_cmd->se_sess;
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>  	if (list_empty(&se_cmd->se_cmd_list)) {
> -		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +		spin_unlock(&se_sess->sess_cmd_lock);

Wait, who has this locked?  You took out the call to spin_lock_* above.

And why not _irqstore() anymore?

thanks,

greg k-h
