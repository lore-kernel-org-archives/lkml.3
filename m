Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3BCOl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:41:27 -0500
Received: from fieldses.org ([174.143.236.118]:54862 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3BCOlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:41:25 -0500
Date: Sun, 3 Feb 2013 09:41:23 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20130203144123.GA22854@fieldses.org>
References: <20130202130403.a29346b583a802ed6ce6880b@canb.auug.org.au>
 <20130202125719.GF30668@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202125719.GF30668@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 07:57:19AM -0500, J. Bruce Fields wrote:
> On Sat, Feb 02, 2013 at 01:04:03PM +1100, Stephen Rothwell wrote:
> > Hi,
> > 
> > After merging the nfsd tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > fs/nfs/dns_resolve.c: In function 'nfs_dns_resolver_cache_init':
> > fs/nfs/dns_resolve.c:375:4: error: 'struct cache_detail' has no member named 'cache_upcall'
> > fs/nfs/dns_resolve.c:375:35: warning: left-hand operand of comma expression has no effect [-Wunused-value]
> > fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> > fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> > fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> > fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> > fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> > fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> > 
> > Caused by commit aab982cb5dfb ("SUNRPC: remove cache_detail->cache_upcall
> > callback").
> 
> Yes, I knew why we'd introduced cache_upcall, so I'm not sure how I
> overlooked that.  It must have slipped through testing because I didn't
> set CONFIG_NFS_USE_KERNEL_DNS.
> 
> We may just be able to revert that patch....  I can take care of that by
> tomorrow.

Stanislav, any objections to this?

--b.

commit 8a55a995d3bada0cd0fc67be92a9e389edf709f8
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Sat Feb 2 07:49:01 2013 -0500

    Revert "SUNRPC: remove cache_detail->cache_upcall callback"
    
    This reverts commit aab982cb5dfb13405236009a6fa24807ee93f62c "SUNRPC:
    remove cache_detail->cache_upcall callback", which overlooked a
    cache_upcall user in fs/nfs/dns_resolve.c.
    
    Also note 517eb5600b455b608fb4cf38e403909a82c76100 "SUNRPC: introduce
    cache_detail->cache_request callback" missed initializing
    ->cache_request in the same file.
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
index 0ff1f4c..794b237 100644
--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -373,6 +373,7 @@ int nfs_dns_resolver_cache_init(struct net *net)
 	cd->name = "dns_resolve",
 	cd->cache_put = nfs_dns_ent_put,
 	cd->cache_upcall = nfs_dns_upcall,
+	cd->cache_request = nfs_dns_request;
 	cd->cache_parse = nfs_dns_parse,
 	cd->cache_show = nfs_dns_show,
 	cd->match = nfs_dns_match,
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 30a572d..b1e367d 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -67,6 +67,11 @@ static void expkey_request(struct cache_detail *cd,
 	(*bpp)[-1] = '\n';
 }
 
+static int expkey_upcall(struct cache_detail *cd, struct cache_head *h)
+{
+	return sunrpc_cache_pipe_upcall(cd, h);
+}
+
 static struct svc_expkey *svc_expkey_update(struct cache_detail *cd, struct svc_expkey *new,
 					    struct svc_expkey *old);
 static struct svc_expkey *svc_expkey_lookup(struct cache_detail *cd, struct svc_expkey *);
@@ -240,6 +245,7 @@ static struct cache_detail svc_expkey_cache_template = {
 	.hash_size	= EXPKEY_HASHMAX,
 	.name		= "nfsd.fh",
 	.cache_put	= expkey_put,
+	.cache_upcall	= expkey_upcall,
 	.cache_request	= expkey_request,
 	.cache_parse	= expkey_parse,
 	.cache_show	= expkey_show,
@@ -333,6 +339,11 @@ static void svc_export_request(struct cache_detail *cd,
 	(*bpp)[-1] = '\n';
 }
 
+static int svc_export_upcall(struct cache_detail *cd, struct cache_head *h)
+{
+	return sunrpc_cache_pipe_upcall(cd, h);
+}
+
 static struct svc_export *svc_export_update(struct svc_export *new,
 					    struct svc_export *old);
 static struct svc_export *svc_export_lookup(struct svc_export *);
@@ -702,6 +713,7 @@ static struct cache_detail svc_export_cache_template = {
 	.hash_size	= EXPORT_HASHMAX,
 	.name		= "nfsd.export",
 	.cache_put	= svc_export_put,
+	.cache_upcall	= svc_export_upcall,
 	.cache_request	= svc_export_request,
 	.cache_parse	= svc_export_parse,
 	.cache_show	= svc_export_show,
diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index d9402ea..d863cd8 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -140,6 +140,12 @@ idtoname_request(struct cache_detail *cd, struct cache_head *ch, char **bpp,
 }
 
 static int
+idtoname_upcall(struct cache_detail *cd, struct cache_head *ch)
+{
+	return sunrpc_cache_pipe_upcall(cd, ch);
+}
+
+static int
 idtoname_match(struct cache_head *ca, struct cache_head *cb)
 {
 	struct ent *a = container_of(ca, struct ent, h);
@@ -186,6 +192,7 @@ static struct cache_detail idtoname_cache_template = {
 	.hash_size	= ENT_HASHMAX,
 	.name		= "nfs4.idtoname",
 	.cache_put	= ent_put,
+	.cache_upcall	= idtoname_upcall,
 	.cache_request	= idtoname_request,
 	.cache_parse	= idtoname_parse,
 	.cache_show	= idtoname_show,
@@ -315,6 +322,12 @@ nametoid_request(struct cache_detail *cd, struct cache_head *ch, char **bpp,
 }
 
 static int
+nametoid_upcall(struct cache_detail *cd, struct cache_head *ch)
+{
+	return sunrpc_cache_pipe_upcall(cd, ch);
+}
+
+static int
 nametoid_match(struct cache_head *ca, struct cache_head *cb)
 {
 	struct ent *a = container_of(ca, struct ent, h);
@@ -353,6 +366,7 @@ static struct cache_detail nametoid_cache_template = {
 	.hash_size	= ENT_HASHMAX,
 	.name		= "nfs4.nametoid",
 	.cache_put	= ent_put,
+	.cache_upcall	= nametoid_upcall,
 	.cache_request	= nametoid_request,
 	.cache_parse	= nametoid_parse,
 	.cache_show	= nametoid_show,
diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index ea927ea..303399b 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -80,6 +80,9 @@ struct cache_detail {
 	char			*name;
 	void			(*cache_put)(struct kref *);
 
+	int			(*cache_upcall)(struct cache_detail *,
+						struct cache_head *);
+
 	void			(*cache_request)(struct cache_detail *cd,
 						 struct cache_head *ch,
 						 char **bpp, int *blen);
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 1bd18af..3d51d03 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -182,6 +182,12 @@ static void rsi_request(struct cache_detail *cd,
 	(*bpp)[-1] = '\n';
 }
 
+static int rsi_upcall(struct cache_detail *cd, struct cache_head *h)
+{
+	return sunrpc_cache_pipe_upcall(cd, h);
+}
+
+
 static int rsi_parse(struct cache_detail *cd,
 		    char *mesg, int mlen)
 {
@@ -269,6 +275,7 @@ static struct cache_detail rsi_cache_template = {
 	.hash_size	= RSI_HASHMAX,
 	.name           = "auth.rpcsec.init",
 	.cache_put      = rsi_put,
+	.cache_upcall   = rsi_upcall,
 	.cache_request  = rsi_request,
 	.cache_parse    = rsi_parse,
 	.match		= rsi_match,
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 82f4c29..5c1ca55 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -196,9 +196,9 @@ EXPORT_SYMBOL_GPL(sunrpc_cache_update);
 
 static int cache_make_upcall(struct cache_detail *cd, struct cache_head *h)
 {
-	if (!cd->cache_request)
+	if (!cd->cache_upcall)
 		return -EINVAL;
-	return sunrpc_cache_pipe_upcall(cd, h);
+	return cd->cache_upcall(cd, h);
 }
 
 static inline int cache_is_valid(struct cache_detail *detail, struct cache_head *h)
@@ -1609,7 +1609,7 @@ static int create_cache_proc_entries(struct cache_detail *cd, struct net *net)
 	if (p == NULL)
 		goto out_nomem;
 
-	if (cd->cache_request || cd->cache_parse) {
+	if (cd->cache_upcall || cd->cache_parse) {
 		p = proc_create_data("channel", S_IFREG|S_IRUSR|S_IWUSR,
 				     cd->u.procfs.proc_ent,
 				     &cache_file_operations_procfs, cd);
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 002ddd9..6d4944f 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -157,6 +157,11 @@ static void ip_map_request(struct cache_detail *cd,
 	(*bpp)[-1] = '\n';
 }
 
+static int ip_map_upcall(struct cache_detail *cd, struct cache_head *h)
+{
+	return sunrpc_cache_pipe_upcall(cd, h);
+}
+
 static struct ip_map *__ip_map_lookup(struct cache_detail *cd, char *class, struct in6_addr *addr);
 static int __ip_map_update(struct cache_detail *cd, struct ip_map *ipm, struct unix_domain *udom, time_t expiry);
 
@@ -465,6 +470,11 @@ static void unix_gid_request(struct cache_detail *cd,
 	(*bpp)[-1] = '\n';
 }
 
+static int unix_gid_upcall(struct cache_detail *cd, struct cache_head *h)
+{
+	return sunrpc_cache_pipe_upcall(cd, h);
+}
+
 static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, uid_t uid);
 
 static int unix_gid_parse(struct cache_detail *cd,
@@ -567,6 +577,7 @@ static struct cache_detail unix_gid_cache_template = {
 	.hash_size	= GID_HASHMAX,
 	.name		= "auth.unix.gid",
 	.cache_put	= unix_gid_put,
+	.cache_upcall	= unix_gid_upcall,
 	.cache_request	= unix_gid_request,
 	.cache_parse	= unix_gid_parse,
 	.cache_show	= unix_gid_show,
@@ -864,6 +875,7 @@ static struct cache_detail ip_map_cache_template = {
 	.hash_size	= IP_HASHMAX,
 	.name		= "auth.unix.ip",
 	.cache_put	= ip_map_put,
+	.cache_upcall	= ip_map_upcall,
 	.cache_request	= ip_map_request,
 	.cache_parse	= ip_map_parse,
 	.cache_show	= ip_map_show,
