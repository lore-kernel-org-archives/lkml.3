Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3FQSUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:20:43 -0400
Received: from mx12.netapp.com ([216.240.18.77]:56563 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab3FQSUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:20:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,882,1363158000"; 
   d="scan'208";a="65506722"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlayton@redhat.com" <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/4] SUNRPC: fix races on PipeFS MOUNT notifications
Thread-Topic: [PATCH v2 2/4] SUNRPC: fix races on PipeFS MOUNT notifications
Thread-Index: AQHOZrF6v+dkhqG430WNjUF3loQYrpk6tqMA
Date: Mon, 17 Jun 2013 18:20:28 +0000
Message-ID: <1371493226.9595.5.camel@leira.trondhjem.org>
References: <20130611143725.16046.17279.stgit@localhost.localdomain>
	 <20130611143917.16046.15791.stgit@localhost.localdomain>
In-Reply-To: <20130611143917.16046.15791.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.117]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <20FCEC3514F7A94C91D80A38D1F1059E@hq.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 18:39 +0400, Stanislav Kinsbursky wrote:
> Below are races, when RPC client can be created without PiepFS dentries
> 
> CPU#0					CPU#1
> -----------------------------		-----------------------------
> rpc_new_client				rpc_fill_super
> rpc_setup_pipedir
> mutex_lock(&sn->pipefs_sb_lock)
> rpc_get_sb_net == NULL
> (no per-net PipeFS superblock)
> 					sn->pipefs_sb = sb;
> 					notifier_call_chain(MOUNT)
> 					(client is not in the list)
> rpc_register_client
> (client without pipes dentries)
> 
> To fix this patch:
> 1) makes PipeFS mount notification call with pipefs_sb_lock being held.
> 2) releases pipefs_sb_lock on new SUNRPC client creation only after
> registration.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> Cc: stable@vger.kernel.org

Hi Stanislav,

This isn't going to apply to the stable kernels without the cleanup
patch. Could you please reorganise this patch series so that the cleanup
comes last.

Thanks,
  Trond


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
