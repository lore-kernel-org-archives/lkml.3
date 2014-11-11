Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaKKT7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:59:48 -0500
Received: from mout.gmx.net ([212.227.15.15]:55957 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbaKKT7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:59:47 -0500
Message-ID: <546269AE.4050200@gmx.de>
Date: Tue, 11 Nov 2014 20:55:26 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
CC: Eric Paris <eparis@parisplace.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ftruncate, truncate: create fanotify events
References: <20141007192330.GE30038@quack.suse.cz> <1414100107-3750-1-git-send-email-xypron.glpk@gmx.de> <20141110203029.GA8125@quack.suse.cz> <20141111073415.GA21776@infradead.org> <20141111110943.GD10456@quack.suse.cz>
In-Reply-To: <20141111110943.GD10456@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:regNcR0VbE7yz1I996fwJonrR3eiUnvv/uyJHyHI6CHNJhi0JRP
 6ri2x3J7qwU0rLdGsyTGKX5l3YbzIPCYYKfDS5WSjbUdEEBdmwPxYAIGULBNH7usgIg9YK6
 5yGQNInURIYZheLft4uu+wDFarQqDKCoLQ6IQIxd0fL+oy3Qpk0+qXd0Ys7GwIZOgfNKG+t
 svOPVnQJgifUhuIQeWhXg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.2014 12:09, Jan Kara wrote:
> On Mon 10-11-14 23:34:15, Christoph Hellwig wrote:
>> On Mon, Nov 10, 2014 at 09:30:29PM +0100, Jan Kara wrote:
>>>    So what I somewhat dislike about this patch is that notify_change() is
>>> sometimes called with dentry and sometimes with path. That way it's not
>>> completely clear when fanotify events will be generated and when not.

No. With my patch notify_change is still only called with dentry.
It is only new function notify_change_path which will be called with a path.
And this function will only be called from do_truncate up to now.

>>> Sadly it isn't easy to provide struct path in all the places where we are
>>> calling notify_change() so I'm not sure what would a better solution look
>>> like either :(

We only want to create FAN_MODIFY events for ATTR_SIZE. So only for 
these events we need a path.

To my knowledge notify_change is called with ATTR_SIZE from 
do_truncate(), ecryptfs_truncate() and will be called with ATTR_SIZE 
from ovl_setattr() for a truncation.

ecryptfs_dentry_to_lower_path() could be used in ecryptfs_truncate() to 
obtain a path.
ovl_path_upper() could be used in ovl_setattr() to obtain a path.

>>
>> I suspect the right thing to do is to split out the truncate path
>> from notify_change, as it's fairly different anyway.
>    Yeah, that would make sense. I wanted to say it's quite a lot of work to
> change all the filesystems (where the separation of truncate path makes
> sense as well IMHO) but actually it's possible to just do the separation at
> the VFS level and still call ->setattr() fs callback for now. Heinrich will
> you look into this?

You seem to agree that struct path has to passed to do_truncate() and 
further to the notification layer.

Currently do_truncate() calls notify_change() which does not accept a 
path argument.

Here the size change is implemented as an attribute change.
Furthermore time attributes are changed.

What do you exactly mean by
 > just do the separation at the virtual file system level
 > and still call ->setattr() fs callback for now.

Do you want to duplicate the logic of notify_change() to a
new function notify_truncate() which will at least have to handle 
ATTR_SIZE, ATTR_FORCE, ATTR_KILL_SUID, ATTR_KILL_SGID, ATTR_FILE and 
time attributes?

And from notify_truncate() call new function fsnotify_truncate() with a 
logic like fsnotify_modify() but accepting a path?

This would result in a lot of code duplication.

In which respect would such a patch be preferable?

Best regards

Heinrich Schuchardt
