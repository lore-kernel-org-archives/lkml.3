Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3CNVV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab3CNVV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:21:26 -0400
Date: Thu, 14 Mar 2013 17:21:07 -0400
From: Dave Jones <davej@redhat.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>, linux-mm@kvack.org,
        user-mode-linux-user@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Davi Arnaut <davi.arnaut@gmail.com>
Subject: Re: SLUB + UML : WARNING: at mm/page_alloc.c:2386
Message-ID: <20130314212107.GA23056@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	linux-mm@kvack.org, user-mode-linux-user@lists.sourceforge.net,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Davi Arnaut <davi.arnaut@gmail.com>
References: <51422008.3020208@gmx.de>
 <CAFLxGvyzkSsUJQMefeB2PcVBykZNqCQe5k19k0MqyVr111848w@mail.gmail.com>
 <514239F7.3050704@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <514239F7.3050704@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 09:58:31PM +0100, Toralf Förster wrote:
 > On 03/14/2013 09:51 PM, richard -rw- weinberger wrote:
 > > Can you please re-run with the attached patch.
 > > I'm wondering how much memory is requested.
 > >>From reading the source I'd say it must be less than PAGE_SIZE.
 > > But such a small allocation would not trigger the WARN_ON()...
 > 
 > 
 > 2013-03-14T21:56:58.000+01:00 trinity sshd[1158]: pam_unix(sshd:session): session opened for user tfoerste by (uid=0)
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: memdup_user: -14
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: ------------[ cut here ]------------
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: WARNING: at mm/page_alloc.c:2386 __alloc_pages_nodemask+0x153/0x750()
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbd14:  [<08342dd8>] dump_stack+0x22/0x24
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbd2c:  [<0807d0da>] warn_slowpath_common+0x5a/0x80
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbd54:  [<0807d1a3>] warn_slowpath_null+0x23/0x30
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbd64:  [<080d3213>] __alloc_pages_nodemask+0x153/0x750
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbdf0:  [<080d3838>] __get_free_pages+0x28/0x50
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbe08:  [<080fc48f>] __kmalloc_track_caller+0x3f/0x180
 > 2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbe30:  [<080dec82>] memdup_user+0x32/0x70
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbe4c:  [<080dee7e>] strndup_user+0x3e/0x60
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbe68:  [<0811b440>] copy_mount_string+0x30/0x50
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbe7c:  [<0811be0a>] sys_mount+0x1a/0xe0
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbeac:  [<08062a92>] handle_syscall+0x82/0xb0
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbef4:  [<08074e7d>] userspace+0x46d/0x590
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbfec:  [<0805f7cc>] fork_handler+0x6c/0x70
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbffc:  [<5a5a5a5a>] 0x5a5a5a5a
 > 2013-03-14T21:56:59.853+01:00 trinity kernel:
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: ---[ end trace 5bf182a223bd623c ]---
 > 2013-03-14T21:56:59.853+01:00 trinity kernel: memdup_user: -14

hah, strndup_user taking a signed long instead of a size_t as it's length arg.

either it needs to change, or it needs an explicit check for < 1

I wonder how many other paths make it possible to pass negative numbers here.

	Dave

