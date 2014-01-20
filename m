Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaATB2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 20:28:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56766 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaATB2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 20:28:01 -0500
Date: Mon, 20 Jan 2014 01:27:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] fs: export simple_dname for drm drivers.
Message-ID: <20140120012758.GQ10323@ZenIV.linux.org.uk>
References: <1390179284-4824-1-git-send-email-airlied@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390179284-4824-1-git-send-email-airlied@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 10:54:44AM +1000, Dave Airlie wrote:
> David Herrmann's changes to use a pseudo filesystem for drm's shared
> inodes requires this be exported for drm to build as a module.
> 
> I'd like to merge this via the drm tree, so please ack.

Having looked through these patches...  The problem is that you'll get
your module impossible to unload.  Sane solution:

static struct vfsmount *drm_mnt;
static int count;
struct inode *drm_alloc_inode(void)
{
	struct inode *res;
	int err = simple_pin_fs(&drm_fs, &drm_mnt, &count);
	if (err)
		return ERR_PTR(err);
	res = alloc_anon_inode(drm_mnt->mnt_sb);
	if (IS_ERR(res))
		simple_release_fs(&drm_mnt, &count);
	return res;
}

/* call from drm_free_dev() */
void drm_put_anon_inode(struct drm_device *dev)
{
	iput(dev->anon_inode);
	simple_release_fs(&drm_mnt, &count);
}

and lose those kern_mount/kern_umount.
