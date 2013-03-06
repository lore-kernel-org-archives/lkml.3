Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3CFUsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:48:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3CFUsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:48:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/4] UAPI: Fix endianness conditionals in linux/raid/md_p.h
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, sfr@canb.auug.org.au,
        Joakim.Tjernlund@transmode.se, arnd@arndb.de,
        Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, akpm@linux-foundation.org
Date: Wed, 06 Mar 2013 20:47:51 +0000
Message-ID: <20130306204751.31327.18239.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130306204724.31327.43118.stgit@warthog.procyon.org.uk>
References: <20130306204724.31327.43118.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be compared
against __BYTE_ORDER in preprocessor conditionals where these are exposed to
userspace (that is they're not inside __KERNEL__ conditionals).

However, in the main kernel the norm is to check for "defined(__XXX_ENDIAN)"
rather than comparing against __BYTE_ORDER and this has incorrectly leaked
into the userspace headers.

The definition of struct mdp_superblock_s in linux/raid/md_p.h is wrong in this
way.  Note that userspace will likely interpret the ordering of the fields
incorrectly as the big-endian variant on a little-endian machines - depending
on header inclusion order.

[!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
be better to fix the ordering of events_hi, events_lo, cp_events_hi and
cp_events_lo in struct mdp_superblock_s / typedef mdp_super_t.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Neil Brown <neilb@suse.de>
cc: linux-raid@vger.kernel.org
---

 include/uapi/linux/raid/md_p.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index ee75353..fe1a540 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -145,16 +145,18 @@ typedef struct mdp_superblock_s {
 	__u32 failed_disks;	/*  4 Number of failed disks		      */
 	__u32 spare_disks;	/*  5 Number of spare disks		      */
 	__u32 sb_csum;		/*  6 checksum of the whole superblock        */
-#ifdef __BIG_ENDIAN
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
 	__u32 events_hi;	/*  7 high-order of superblock update count   */
 	__u32 events_lo;	/*  8 low-order of superblock update count    */
 	__u32 cp_events_hi;	/*  9 high-order of checkpoint update count   */
 	__u32 cp_events_lo;	/* 10 low-order of checkpoint update count    */
-#else
+#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
 	__u32 events_lo;	/*  7 low-order of superblock update count    */
 	__u32 events_hi;	/*  8 high-order of superblock update count   */
 	__u32 cp_events_lo;	/*  9 low-order of checkpoint update count    */
 	__u32 cp_events_hi;	/* 10 high-order of checkpoint update count   */
+#else
+#error unspecified endianness
 #endif
 	__u32 recovery_cp;	/* 11 recovery checkpoint sector count	      */
 	/* There are only valid for minor_version > 90 */

