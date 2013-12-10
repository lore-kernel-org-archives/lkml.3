Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3LJUZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:25:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab3LJUZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:25:27 -0500
Message-ID: <1386707123.23829.23.camel@flatline.rdu.redhat.com>
Subject: Re: SELinux change in 3.13 causes sync hang
From: Eric Paris <eparis@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Anand Avati <avati@redhat.com>, James Morris <jmorris@namei.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 15:25:23 -0500
In-Reply-To: <CA+5PVA56s68i_Ad+FiT_8_OHZt3BeZdpqdzc6RVbgOx68=MaOQ@mail.gmail.com>
References: <CA+5PVA56s68i_Ad+FiT_8_OHZt3BeZdpqdzc6RVbgOx68=MaOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still believe (assuming Josh says it tests ok) that a revert is a
reasonable fix until next window.  But I might know the actual problem:

Lets assume policy says:
   fuse.gluster == use_xattr

Lets assume this function is called with
sb->s_type->name == fuse
sb->s_subtype == NULL

int security_fs_use(struct super_block *sb)
{
        int rc = 0;
        struct ocontext *c;
        struct superblock_security_struct *sbsec = sb->s_security;
        const char *fstype = sb->s_type->name;
        const char *subtype = (sb->s_subtype && sb->s_subtype[0]) ? sb->s_subtype : NULL;
        struct ocontext *base = NULL;

        read_lock(&policy_rwlock);

        for (c = policydb.ocontexts[OCON_FSUSE]; c; c = c->next) {
                char *sub;
                int baselen;

                baselen = strlen(fstype);

		**********  assume c == the above rule   name = fuse.gluster

                /* if base does not match, this is not the one */
                if (strncmp(fstype, c->u.name, baselen))    <----------- this will match
                        continue;

                /* if there is no subtype, this is the one! */
                if (!subtype)   <--------------------------------------- we will break here!
                        break;
[snip]
        }
[snip]
        if (c) {
                sbsec->behavior = c->v.behavior;

So we just matched on the fuse.gluster rule even though the mount in
question was fstype=fuse subtype=NULL     So we will try to use xattrs
on a fuse FS that can/will deadlock.

I'll try to write a patch to fix that logic...

-Eric

