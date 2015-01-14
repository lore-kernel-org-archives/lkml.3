Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbbANPZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:25:24 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:46906 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbbANPZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:25:23 -0500
Date: Wed, 14 Jan 2015 17:25:01 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Calvin Owens <calvinowens@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-ID: <20150114152501.GB9820@node.dhcp.inet.fi>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:20:29PM -0800, Calvin Owens wrote:
> Commit b76437579d1344b6 ("procfs: mark thread stack correctly in
> proc/<pid>/maps") introduced logic to mark thread stacks with the
> "[stack:%d]" marker in /proc/<pid>/maps.
> 
> This causes reading /proc/<pid>/maps to take O(N^2) time, where N is
> the number of threads sharing an address space, since each line of
> output requires iterating over the VMA list looking for ranges that
> correspond to the stack pointer in any task's register set. When
> dealing with highly-threaded Java applications, reading this file can
> take hours and trigger softlockup dumps.
> 
> Eliminating the "[stack:%d]" marker is not a viable option since it's
> been there for some time, and I don't see a way to do the stack check
> more efficiently that wouldn't end up making the whole thing really
> ugly.
> 
> The use case I'm specifically concerned with is the lsof command, so
> this patch adds an additional file, "mapped_files", that simply
> iterates over the VMAs associated with the task and outputs a
> newline-delimited list of the pathnames of the files associated with
> the VMAs, if any.
> 
> This gives lsof and suchlike a way to determine the pathnames of files
> mapped into a process without incurring the O(N^2) behavior of the
> maps file.

We already have /proc/PID/map_files/ directory which lists all mapped
files. Should we consider relaxing permission checking there and move it
outside CONFIG_CHECKPOINT_RESTORE instead?

Restriction to CAP_SYSADMIN for follow_link is undertansble, but why do we
restrict readdir and readlink?

-- 
 Kirill A. Shutemov
