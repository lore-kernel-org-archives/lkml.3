Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3EMJV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3EMJV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:21:26 -0400
Subject: Re: linux-next: Tree for May 8 (dlm)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: David Teigland <teigland@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <518BD826.4040403@infradead.org>
References: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
	 <518A93BD.3020300@infradead.org>
	 <20130509094745.049e46fff25f357e7eb50123@canb.auug.org.au>
	 <20130509165028.GA18077@redhat.com>  <518BD826.4040403@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 13 May 2013 10:18:32 +0100
Message-ID: <1368436712.2882.14.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2013-05-09 at 10:08 -0700, Randy Dunlap wrote:
> On 05/09/13 09:50, David Teigland wrote:
> > On Thu, May 09, 2013 at 09:47:45AM +1000, Stephen Rothwell wrote:
> >> [Just forwarding to David ...]
> >>
> >> On Wed, 08 May 2013 11:04:45 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> >>>
> >>> on x86_64:
> >>>
> >>> when CONFIG_GFS2_FS_LOCKING_DLM=y and CONFIG_DLM=m:
> >>>
> >>> fs/built-in.o: In function `gfs2_lock':
> >>> file.c:(.text+0xa512c): undefined reference to `dlm_posix_get'
> >>> file.c:(.text+0xa5140): undefined reference to `dlm_posix_unlock'
> >>> file.c:(.text+0xa514a): undefined reference to `dlm_posix_lock'
> > 
> > gfs2/file.c calls the dlm directly, so I suppose gfs2 itself needs
> > to depend on the dlm.  It's been like this for a long time, so I
> > don't know why it only appeared now.
> 
> Agreed to both statements.
> 
> >>> fs/built-in.o: In function `gdlm_cancel':
> >>> lock_dlm.c:(.text+0xb3f57): undefined reference to `dlm_unlock'
> >>> fs/built-in.o: In function `gdlm_unmount':
> >>> lock_dlm.c:(.text+0xb40ff): undefined reference to `dlm_release_lockspace'
> >>> fs/built-in.o: In function `sync_unlock.isra.4':
> >>> lock_dlm.c:(.text+0xb420d): undefined reference to `dlm_unlock'
> >>> fs/built-in.o: In function `sync_lock.isra.5':
> >>> lock_dlm.c:(.text+0xb42d9): undefined reference to `dlm_lock'
> >>> fs/built-in.o: In function `gdlm_put_lock':
> >>> lock_dlm.c:(.text+0xb45e7): undefined reference to `dlm_unlock'
> >>> fs/built-in.o: In function `gdlm_mount':
> >>> lock_dlm.c:(.text+0xb4928): undefined reference to `dlm_new_lockspace'
> >>> lock_dlm.c:(.text+0xb4c75): undefined reference to `dlm_release_lockspace'
> >>> fs/built-in.o: In function `gdlm_lock':
> >>> lock_dlm.c:(.text+0xb529f): undefined reference to `dlm_lock'
> > 
> > lock_dlm.c is GFS2_FS_LOCKING_DLM which depends on DLM.
> > Is that not correct?
> 
> The problem is that GFS2_FS_LOCKING_DLM is a bool.  It depends on DLM,
> which is a tristate with a value of 'm', so the bool is true (as long
> as DLM != 'n').
> 
> One option is to make GFS2_FS_LOCKING_DLM depend on "DLM != n", but a
> better fix is to make GFS2_FS depend on DLM, like you said above.
> 
> 

Does this look correct? As Dave says this has not changed for some time.
It seems that every time we try to get this right, there is always some
corner case that is missed :( 

We can't make GFS2_FS depend on DLM as otherwise there would be no
reason to have GFS2_FS_LOCKING_DLM, at least if I've understood the
issue here correctly. So I've come up with the following... does it look
ok?


diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index eb08c9e..edbad96 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -26,7 +26,7 @@ config GFS2_FS
 config GFS2_FS_LOCKING_DLM
 	bool "GFS2 DLM locking"
 	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
-		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
+		HOTPLUG && (DLM!=n) && CONFIGFS_FS && SYSFS
 	help
 	  Multiple node locking module for GFS2
 


