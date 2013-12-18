Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3LRHRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 02:17:48 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56119 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3LRHRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 02:17:47 -0500
Message-ID: <52B14C10.4060709@cs.wisc.edu>
Date: Wed, 18 Dec 2013 01:17:36 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: Vaughan Cao <vaughan.cao@oracle.com>
CC: James.Bottomley@suse.de, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iscsi: conn error (1020) each time iscsi session logout
References: <1387349221-18501-1-git-send-email-vaughan.cao@oracle.com>
In-Reply-To: <1387349221-18501-1-git-send-email-vaughan.cao@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 12:47 AM, Vaughan Cao wrote:
> We do a normal login/logout process to iscsi server. iscsiadm report success,
> but we always see the following error just before conn shutdown in dmesg.
> 
> Oct 15 05:30:09 vmhodtest019 iscsid: Connection1:0 to [target:
> iqn.1986-03.com.sun:02:7b863a18-045a-cb04-c686-841f17df2f9c, portal:
> 10.182.32.162,3260] through [iface: default] is operational now
> Oct 15 05:30:42 vmhodtest019 kernel:  connection1:0: detected conn error
> (1020)
> Oct 15 05:30:42 vmhodtest019 iscsid: Connection1:0 to [target:
> iqn.1986-03.com.sun:02:7b863a18-045a-cb04-c686-841f17df2f9c, portal:
> 10.182.32.162,3260] through [iface: default] is shutdown.
> 
> It's because iscsi_tcp module evaluates socket state in data_ready() callback,
>  and that detect the socket close. However, this socket close on target peer 
> is in response to the logout request from initiator. So this is not an error 
> that should be reported out. I quiesce it by checking session state and err 
> value accordingly.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 415f2c0..84171ef 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1360,6 +1360,12 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
>  		spin_unlock_bh(&session->lock);
>  		return;
>  	}
> +	/* Target closed the connection in response to logout */
> +	if (session->state == ISCSI_STATE_LOGGING_OUT &&
> +		err == ISCSI_ERR_TCP_CONN_CLOSE) {
> +		spin_unlock_bh(&session->lock);
> +		return;
> +	}
>  
>  	if (conn->stop_stage == 0)
>  		session->state = ISCSI_STATE_FAILED;
> 


Someone just sent a patch for this.

commit c712495e687e221b00bddae96247dbf6ffbc6200
Author: Chris Leech <cleech@redhat.com>
Date:   Thu Sep 26 09:09:44 2013 -0700

    [SCSI] iscsi_tcp: consider session state in iscsi_sw_sk_state_check


