Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaDYBkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:40:05 -0400
Received: from mail.phunq.net ([184.71.0.62]:52730 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaDYBkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:40:02 -0400
X-Greylist: delayed 2664 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 21:40:02 EDT
Message-ID: <5359B279.7070003@partner.samsung.com>
Date: Thu, 24 Apr 2014 17:55:21 -0700
From: Daniel Phillips <d.phillips@partner.samsung.com>
Reply-To: daniel@phunq.net
Organization: Samsung
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Tux3 Report: Untar Unleashed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


It is about time to post Tux3 patches for review. Almost. Running the 
classic kernel untar test on an older 60 MB/sec hard disk turned up a 
performance gap versus Ext4 by a factor of six. Hmm, that is in the 
range where it could be a basic design bug, we need to do something.


Tux3 performed fine on the actual untar, but syncing those thousands of 
small files to disk was slow. The cause turned out to be multiple 
issues. Two were unimplemented design features. For every file, we were 
writing a btree root and a leaf block with pointers to data extents. 
Instead, most btrees can be "zero depth" with just a leaf block and no 
index block. And many files are just a single extent so the btree is not 
needed at all. When writing lots of small files, we were transferring up 
to three times more blocks than necessary.


The kernel tarball showed a metadata-to-data ratio of about 1.2. This is 
way too high, it should be less than a tenth of that. After factoring 
out those extra blocks, a huge performance gap still remains. This must 
have something to do with seeking, but our disk layout for this load is 
pretty good, so what is going on?


It turns out to be important not only to write to the right place, but 
at the right time. The block scheduler tries to merge physically 
contiguous requests even when submitted out of order, but if the 
requests are too far apart in time, an earlier request may have already 
left the queue by the time an adjacent request shows up. This causes 
extra, costly seeks on spinning disks. Ideally, we want our writes 
contiguous in both time and space. Then the disk hardware should be able 
to make seek costs effectively disappear and stream the data out at 
close to media speed.


Fixes for these issues took the form of patches from Hirofumi to 
eliminate redundant btree roots and submit metadata writes in a better 
order for block scheduling, and a patch from me to implement a planned 
"direct extent" feature to eliminate btrees completely for small files. 
Iterative improvements went something like this:


* Start: 60 seconds to sync but Ext4 only needs 10 seconds

* Eliminate most btree roots => now sync in 53 seconds

* Submit file btree together with data => sync in 19 seconds

* Eliminate btree complete for small files => 15 seconds

* Flush inode table blocks after all data => 8 seconds


We ended up with:


untar:

real 0m2.706s

user 0m0.360s

sys 0m2.160s


sync:

real 0m8.651s

user 0m0.000s

sys 0m0.024s


Ext4 takes about 4 seconds to untar and 10 seconds to sync, turning in a 
respectable 50 MB/sec write bandwidth on a 62 MB/sec disk. Tux3 now 
syncs at 60 MB/sec, or 97% of raw media bandwidth. So we went from 500% 
slower to 23% faster, woohoo. The cost for this is that we dropped out 
of sight for a few weeks. Maybe it was worth it because the performance 
artifact was so big that it could have been a major design deficiency 
instead of what it really was: leaving some details for later.


When we checked read performance on the untarred tree, we immediately 
saw mixed results. Re-tarring the kernel tree is faster than Ext4, but 
directory listing is slower by a multiple. So we need to analyze and fix 
ls without breaking the good tar and untar behavior. The question is, is 
it worth another delay before putting Tux3 patches up for review?


I think not. In fact, by going quiet when we hit these things, we 
detract from the spectator sport aspect of open source. It might not be 
any faster to work in public, but it is more fun. Plus, it engraves a 
record on the internet as a guide for the next effort to invent a new 
and wonderful filesystem. It is hard to overstate the value to our 
project of all the historical chatter about design and development 
process for Ext4 and other Linux filesystems. We often find ourselves 
retracing the same learning processes. By doing this work in public, we 
give something back.


Improving ls performance to Ext4 standards may just be a matter of 
implementing inode table readahead, or it might be that plus something 
else. In any case, this will go on the longish list of important issues 
that are not central.


Inline data is a related item already on that list. There is a nice plan 
for it, where the same design feature handles inline files and tail 
packing, similar to extended attributes. In particular, most directories 
in the kernel tarball are small enough to inline, which could speed up 
ls significantly. With most files and directories inlined, a Tux3 
filesystem becomes a single, fatter btree, with different issues and 
tradeoffs. On the whole, I expect substantial improvements in both space 
utilization and performance. The final chapter in the tar performance 
saga has yet to be written.

We also need to ask why we are putting so much effort into performing 
well on spinning disks, which are rapidly disappearing. Two reasons. 
First, spinning disks are not gone yet, they are just migrating to a 
backend storage role. Second, optimizations for spinning disk are 
helpful for solid state storage more often than not. In this case, 
keeping related requests close together in time lets the flash 
translation layer pack its erase blocks better, reducing write 
multiplication during space recovery, and in turn increasing media life 
and performance. So it is too soon to forget about the idiosyncrasies 
and challenges of traditional rotating media, perhaps ten or twenty 
years too soon.


Regards,


Daniel


