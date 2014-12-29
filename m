Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaL2A7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:59:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:60518 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaL2A7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:59:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,657,1413270000"; 
   d="scan'208";a="630148346"
From: "Ma, Xindong" <xindong.ma@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "ionut.m.alexa@gmail.com" <ionut.m.alexa@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Di" <di.zhang@intel.com>,
        "Sun, Zhonghua" <zhonghua.sun@intel.com>
Subject: RE: [PATCH] move exit_task_work() before exit_fs().
Thread-Topic: [PATCH] move exit_task_work() before exit_fs().
Thread-Index: AQHQITL3mdB5I21gqEyyZHrRUq+JSpylwB0Q
Date: Mon, 29 Dec 2014 00:58:59 +0000
Message-ID: <3917C05D9F83184EAA45CE249FF1B1DD0266FC53@SHSMSX103.ccr.corp.intel.com>
References: <1419579926-28512-1-git-send-email-xindong.ma@intel.com>
 <20141226173849.GA9460@redhat.com>
In-Reply-To: <20141226173849.GA9460@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On 12/26, Leon Ma wrote:
> >
> > We encountered following panic. The scenario is the process is exiting
> > and executing its task work. When closing dev node, the driver
> > triggers a firmware reload according to device status. Because task->fs is
> set to NULL in exit_fs(), panic happens.
> 
> I think this should be fixed somewhere else...
Yes, for this panic, I also think driver is not perfect and need a fix. But kernel should not add the limitation like this...
> 
> > Task work is a common interface, we should not limite the resource the
> user will utilize.
> 
> Exactly. And note that with this patch exit_mm()..disassociate_ctty() paths
> can't use task works.
I don't get this. Currently disassociate_ctty() is also called after exit_mm() and exit_task_work(). My patch didn't change this.
> 
> Not to mention that this patch moves exit_files() up, even before exit_mm(),
> without any explanation.
Moving exit_files() up is because exit_files() closes files and add tasks to task works.
> 
> Add Al. May be we can move exit_fs() down after exit_task_work(), I dunno,
> but to me it would be better to change the driver.
> 
I'm OK with this suggestion to fix this issue. I'm not sure whether in the future task work users will access other resources and expose other issues.
