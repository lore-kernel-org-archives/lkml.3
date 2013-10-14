Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3JNMrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:47:18 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:60097 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3JNMrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:47:16 -0400
Date: Mon, 14 Oct 2013 08:47:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCHSET v2] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20131014124712.GA4722@htj.dyndns.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
 <20131006004032.GA3601@kroah.com>
 <20131007170005.GB2481@htj.dyndns.org>
 <20131007231136.GB27270@kroah.com>
 <CAE9FiQV-bs0hiTDSzOR0GREMf=whichBocLPBF_uV09=LjTCtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV-bs0hiTDSzOR0GREMf=whichBocLPBF_uV09=LjTCtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Sorry about the delay.

On Fri, Oct 11, 2013 at 12:11:18PM -0700, Yinghai Lu wrote:
> [  448.189960] ------------[ cut here ]------------
> [  448.195214] WARNING: CPU: 6 PID: 69219 at fs/sysfs/file.c:79
> sysfs_file_ops+0x59/0x70()

So, that's "lockdep_assert_held(sd);" in sysfs_file_ops().

> [  448.273805]  [<ffffffff81248bd9>] sysfs_file_ops+0x59/0x70
> [  448.279973]  [<ffffffff81249628>] sysfs_open_file+0x88/0x330

Triggering from sysfs_open_file()

> [  448.366842] ------------[ cut here ]------------
> [  448.372030] WARNING: CPU: 6 PID: 69219 at fs/sysfs/file.c:79
> sysfs_file_ops+0x59/0x70()
...
> [  448.457806]  [<ffffffff81248cbb>] sysfs_seq_show+0xcb/0x180

and then from sysfs_seq_show(), which is weird because
lockdep_assert_held(sd) checks whether sd's active ref is held and
both do hold them.  Hmm.... ah, right, I forgot about
->ignore_lockdep, we need to skip the assertion for files marked with
ignore_lockdep.  Will send a patch soon.

Thanks.

-- 
tejun
