Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab3FSCbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:31:50 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:15602 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab3FSCbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:31:48 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-51-51c118127ee0
From: Daniel Phillips <d.phillips@partner.samsung.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tux3@tux3.org" <tux3@tux3.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Tux3 Report: Meet Shardmap, the designated successor of HTree
Thread-topic: Tux3 Report: Meet Shardmap, the designated successor of HTree
Thread-index: Ac5slSQ3S8fR6kl3QYecjchdqgU0pA==
Date: Wed, 19 Jun 2013 02:31:45 +0000
Message-id: <1EC23D2B9975384993D85B5DB93AAE8860D35B@sisaex02sj>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.34.5]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9hP10hiYOBBo8n6lns2XuSxeLyrjls
	Fh8OfGZ0YPb49vQVm8fnTXIBTFFcNimpOZllqUX6dglcGVNWbGIpWLmWsaLr7jm2BsbJvYxd
	jJwcEgImEk+XfoCyxSQu3FvP1sXIxSEksIxR4t2mxYwQTi+TxIWvs6Gc+YwSj6/dYQZpYRMw
	k1h6/AwTSEJEYDmjxIunt1i6GDk4hAXcJD69jwSpERHwljgKNhbE1pOYdaWXCaSERUBV4ve0
	XJAwr4C9xMbjO5lAbEagK76fWgNmMwuISzS33mSBuE5AYsme88wQtqjEy8f/WCFsBYkbC5ex
	QtRrSazfeRyqV1viybsLrBDzBSV+TL7HMoFRZBaSsbOQtMxC0jILScsCRpZVjGKlxckFxUnp
	qRXGesWJucWleel6yfm5mxgh8VGzg/HeV5tDjAIcjEo8vA0rDwQKsSaWFVfmHmKU4GBWEuH9
	zHQwUIg3JbGyKrUoP76oNCe1+BAjEwenVAOjhFNu8+/Xhm0VO69HvVl/9/a2u4cTV82MF55w
	MfxQpst7rtnmM7fdO1FzIV/2oyqz1sPZhxnfTxX9Ms8j6PDakscZcRWrI5VPOssHt+2csy+J
	v6w62399YDeb7bzsTQc11Yp63oTu07KtPdNw5f67LMmVW/amNHzMzJYSEc4u0ahRbj7JcOir
	EktxRqKhFnNRcSIApRXx120CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

 From time to time, one may fortunate enough to be blessed with a 
discovery in computer science that succeeds at improving all four of 
performance, scalability, reliability and simplicity. Of these normally 
conflicting goals, simplicity is usually the most elusive. It is 
therefore with considerable satisfaction that I present the results of 
our recent development work in directory indexing technology, which 
addresses some long-standing and vexing scalability problems exhibited 
by HTree, my previous contribution to the art of directory indexing. 
This new approach, Shardmap, will not only enhance Tux3 scalability, but 
provides an upgrade path for Ext4 and Lustre as well. Shardmap is also 
likely to be interesting for high performance database design. Best of 
all, Shardmap is considerably simpler than the technology we expect it 
to replace.

The most interesting thing about Shardmap is that it remained 
undiscovered for so long. I expect that you will agree that this is 
particularly impressive, considering how obvious Shardmap is in 
retrospect. I can only speculate that the reason for not seeing this 
obvious solution is that we never asked the right question. The question 
should have been: how do we fix this write multiplication issue? Instead 
we spent ten years asking: what should be do about this cache 
thrashing?. It turns out that an answer to the former is also an answer 
to the latter.

Now let us proceed without further ado to a brief tour of Shardmap, 
starting with the technology we expect it to replace.

The Problem with HTree

Occasionally we see LKML reports of performance issues in HTree at high 
scale, usually from people running scalability benchmarks. Lustre users 
have encountered these issues in real life. I always tended to shy away 
from those discussions because, frankly, I did not see any satisfactory 
answer, other than that HTree works perfectly well at the scale it was 
designed for and at which it is normally used. Recently I did learn the 
right answer: HTree is unfixable, and this is true of any media backed 
B-Tree index. Let me reiterate: contrary to popular opinion, a media 
backed B-Tree is an abysmally poor choice of information structure for 
any randomly updated indexing load.

But how can this be, doesn't everybody use B-Trees in just this way? 
Yes, and everybody is making a big mistake. Let me explain. The big 
issue is write multiplication. Any index that groups entries together in 
blocks will tend to have nearly every block dirty under a random update 
load. How do we transfer all those dirty blocks to cache incrementally, 
efficiently and atomically? We don't, it just cannot be done. In 
practice, we end up writing out most index blocks multiple times due to 
just a few small changes. For example, at the end of a mass update 
create we may find that each block has been written hundreds of times. 
Media transfer latency therefore dominates the operation.

This obvious issue somehow escaped our attention over the entire time 
HTree has been in service. We have occasionally misattributed degraded 
HTree performance to inode table thrashing. To be sure, thrashing at 
high scale is a known problem with Tree, but it is not the biggest 
problem. That would be write multiplication. To fix this, we need to 
step back and adopt a completely different approach.

Dawning of the Light

I am kind of whacking myself on the forehead about this. For an entire 
decade I thought that HTree could be fixed by incremental improvements 
and consequently devoted considerable energy to that effort, the high 
water mark of which was my PHTree post earlier this year:

    http://phunq.net/pipermail/tux3/2013-January/000026.html

The PHTree design is a respectable if uninspired piece of work that 
fixes all the known issues with HTree except for write multiplication, 
which I expected to be pretty easy. Far from it. The issue is 
fundamental to the nature of B-Trees. Though not hitherto recognized in 
the Linux file system community, academics recognized this issue some 
time ago and have been busy hunting for a solution. During one of our 
sushi meetings in the wilds of Mountain View, Kent Overstreet of BCache 
fame pointed me at this work:

    http://www.tokutek.com/2012/12/fractal-tree-indexing-overview/

Such attempts generally fail to get anywhere close to the efficiency 
levels we have become accustomed to with Ext4 and its ilk. But it got me 
thinking along productive lines. (Thank you Kent!) One day the answer 
just hit me like a slow rolling thunderbolt: instead of committing the 
actual B-Tree to disk we should leave it dirty in cache and just log the 
updates to it. This is obviously write-efficient and ACID friendly. It 
is also a poor solution because it sacrifices recovery latency. In the 
event of a crash we need to read the entire log to reconstruct the dirty 
B-Tree, which could take several minutes. During this time, even though 
the raw directory entries are immediately available, the index is 
unavailable. At the scales we are considering, unindexed directory 
access is roughly the same as no access at all.

Birth of Shardmap

Then a faster moving thunderbolt hit me: why not write out the log in 
many small pieces, each covering a part of the hash range? That way, to 
access a single uncached entry we only suffer the latency of loading one 
small piece of the log. With this improvement, the index becomes 
available immediately on restart.

Eureka! Shardmap was born in the form of a secondary hash index on a 
B-Tree that would kick in under heavy load, and be merged back into the 
primary B-Tree when the load eases up. Shardmap would be a "frontend" 
index on the B-Tree, an concept similar to others we have already 
employed in Tux3. This all seemed like a great idea and I immediately 
began to implement a prototype to get an idea of performance.

A few days into my prototype I was hit by a third and final blinding 
flash when I noticed that the primary B-Tree index is not needed at all: 
the in-cache hash tables together with the hash shards logged to media 
constitute a perfectly fine index all on their own. In fact, when I 
investigated further, I found this arrangement to be superior to B-Tree 
approaches in practically every way. (B-Trees still manage to eke out an 
advantage in certain light out of cache loads, which I will not detail 
here.) Shardmap was suddenly elevated from its humble status as 
temporary secondary index to the glorious role of saving all of us from 
HTree's scalability issues. Probably.

Shardmap is a simple and obvious idea, but is that not always the case 
in retrospect? BSD folks came very close to discovering the same thing 
back around the time I was inventing HTree:

    http://en.wikipedia.org/wiki/Dirhash

At the time I recognized the hash table approach as promising, but 
deeply flawed because of its need to load an entire directory just to 
service a single access. Accordingly, HTree continued to be developed 
and went on to rule the world.

I wish I had thought about that harder. All that remained to do to fix 
the BSD Dirhash approach was log the hash table to media efficiently and 
the result would have been Shardmap, many years ago. Well. Better late 
than never.

The remainder of this post takes a deep dive into the proposition that 
Shardmap is a suitable replacement for HTree, potentially suitable for 
use in Tux3, Ext4, and Lustre.

Design

A Shardmap index consists of a scalable number of index shards, starting 
at one for the smallest indexed directories and increasing to 4096 for a 
billion file directory. The maximum size of each shard also increases 
over this range from 64K to four megabytes. Each shard contains index 
entries for some subset of the hash key range. Each shard entry maps a 
hash key to the logical block number of a directory entry block known to 
contain a name that hashes to that key.

Each shard is represented as an unsorted fifo on disk and a small hash 
table in memory. To search for a name, we use some high bits of the hash 
to look up a cached shard hash in memory. If the shard is not hashed in 
cache, then we load the corresponding shard fifo from media and convert 
it to into a hash table. We walk this list of hash collisions, searching 
each referenced directory block for a match on the name.

Clearly, hash collisions must be rare in order to avoid searching 
multiple, potentially out of cache directory entry blocks. Therefore, we 
compute and store our hash keys at a higher precision than our targeted 
scalability range.

As a directory grows, we scale the shardmap in two ways: 1) Rehash a 
cached shard to a larger number of hash buckets and 2) Reshard a stored 
shard fifo to divide it into multiple, smaller shards. These operations 
are staggered to avoid latency spikes. The reshard operation imposes a 
modest degree of write multiplication on the Shardmap design, 
asymptotically approaching a factor of two. This is far better than the 
factor of several hundred we see with HTree.

The key ideas of Shardmap are: 1) the representation of directory data 
is not the same on media as it is in cache. On media we have fifos, but 
in cache we have hash tables. 2) Updating a fifo is cache efficient. 
Only the tail block of the fifo needs to be present in cache. The cache 
footprint of the media image of a shardmap is therefore just one disk 
block per shard. 3) A small fifo on media is easily loaded and converted 
to an efficient hash table shard on demand. Once in cache, index updates 
are performed by updating the cached hash table and appending the same 
entries to the final block of the shard fifo.

To record deletes durably, Shardmap appends negative fifo entries to 
shard fifos. From time to time, a shard fifo containing delete entries 
will be compacted and rewritten in its entirety to prevent unbounded 
growth. This cleanup operation actually turns out to be the most complex 
bit of code in Shardmap, and it is not very complex.

Like any other kind of Tux3 update, Shardmap updates are required to be 
ACID. The Tux3 block forking mechanism makes this easy: each delta 
transition effectively makes all dirty blocks of a directory read-only. 
While transferring a previous delta to disk, directory entries may be 
created in or removed from directory entry blocks on their way to disk, 
so those blocks will be forked. The tail block of a shard fifo may also 
be forked, and so may directory entry free maps. Under a pure create or 
delete load, the additional cache load caused by page forking will 
normally not be much more than the tail blocks of shard fifos. Other 
loads will perform about as you would expect them to.

The cache footprint of an actively updated Shardmap index is necessarily 
the entire index, true not only of Shardmap, but any randomly updated 
index that groups entries together in blocks. If we contemplate running 
a create test on a billion files, we must provide enough cache to 
accommodate the entire index or we will thrash, it is as simple as that. 
For a billion files we will need about eight gigabytes of cache. That is 
actually not too bad, and reflects Shardmap's compact hash table design. 
Less cache than that will force more disk accesses, and the test will 
consequently run slower but correctly.

Shardmap's appetite for shard cache grows to extreme levels as 
directories grow to billions of files. This is not unexpected, however 
it does mean that we need to take some special care with our kernel 
cache design. A shard hashtable in kernel will be an expanding array of 
pages just as it is in userspace, however we will not have the virtual 
memory hardware available to help us out here[2]. On 32 bit hardware we 
will be using highmem for the cache, with attendant inefficient 
kmap/unmap operations and that will suck, but it will still work better 
than HTree for gigantic directories. For smaller directories we can 
adopt some other cache management strategy in order to avoid performance 
regressions.

Comparison to HTree

Like HTree, Shardmap uses tables of fixed size keys that are hashes of 
names in order to rapidly locate some directory block containing 
standard directory entries.

Unlike HTree, Shardmap has one index entry per directory entry. HTree 
uses one index entry per directory entry block, and is unique in that 
regard. This is one of the key design details that has made HTree so 
hard to beat all this time. It also sounds like a big advantage over 
Shardmap in terms of index size, but actually it is a tie because of 
slack space normally found in B-Tree blocks.

Like HTree, a Shardmap index is mapped logically into directory file 
data blocks (logical metadata in Tux3 parlance). This takes advantage of 
the physical/logical layering of classic Unix filesystem design. In 
concrete terms, it reuses the same cache operations for the index as are 
already implemented for ordinary files and avoids complicating the Tux3 
physical layer at which files and the inode table are defined. It also 
provides a degree of modularity that is aesthetically pleasing in itself.

Unlike HTree, a Shardmap index is not interleaved with directory data. 
We place the index data strictly above the directory entry blocks 
because the index is relatively larger than an HTree index, roughly 20% 
of the directory file. At first we intended to place the Shardmap index 
at a very high logical address, but that plan as discarded when we 
noticed that this adds several levels to the page cache radix tree, 
which slows down all directory block accesses significantly (we measured 
6 nanoseconds per radix tree level).

Our refined layout scheme places the Shardmap index a short distance 
above the currently used directory blocks and relocates it higher as the 
directory expands, so we incur about the same radix tree overhead as 
would be required by a simple unindexed directory[1]. This relocation 
does not impose new overhead because we already must relocate the index 
shards as a directory expands, to break them up and limit reload latency.

Unlike HTree, Shardmap needs to keep track of holes in directory entry 
blocks created by deletions. HTree finesses this detail away by creating 
each new entry at a particular place in the btree corresponding to its 
hash; deleted entry records are simply forgotten in the hope that they 
will eventually be compressed away during a block split operation.

Shardmap employs a free record map for this purpose, with one byte per
directory entry block that indicates the largest directory record 
available in the directory block. To avoid churning this map, it is 
updated lazily - the actual largest free record is never larger than the 
size stored in the map, but may be smaller. If so, a failed search for 
free space in the block will update the free map entry to the actual 
largest size. Conversely, on delete the map is updated to be an 
overestimate of the largest record size. The intention of these
heuristics is to reduce the amount of accounting data that needs to be 
written out under sparse update loads.

At scales of billions of entries, even scanning a byte per directory 
entry block is too expensive, so Shardmap goes on to map the free map 
with an additional map layer where each byte gives the size of the 
largest free directory record covered by the associated free map block. 
Three levels of this structure maps 2**(12*3) = 2**36 directory blocks, 
which should be sufficient for the foreseeable future.

Shardmap uses the elegant Siphash general purpose hash function 
obligingly provided by Aumasson and Bernstein:

    https://131002.net/siphash/

Siphash is a wonderful creation that is easily parametrized in terms of 
mixing rounds to the degree required by the application. Shardmap is not 
as demanding in this regard as HTree, which does not implement delete 
coalescing and is therefore sensitive to slight hash distribution 
anomalies. Shardmap is able to tolerate relatively fewer mixing rounds 
in the interest of higher performance.

Siphash as implemented by Shardmap uses 2 rounds per 8 bytes versus 
HTree's default Halfmd4 which uses 24 more complex rounds per 32 bytes, 
a significant performance win for Shardmap:

    http://lxr.free-electrons.com/source/lib/halfmd4.c#L25
 
https://github.com/OGAWAHirofumi/tux3/blob/master/user/devel/shard.c#L60

Further, the Siphash dispersal pattern is specifically optimized for 
hash table applications. Our recommendation is that existing HTree users 
add Siphash as the default hash function in the interest of improved 
performance.

Performance

With the Shardmap userspace prototype we were able to obtain some early
performance numbers, which I will describe in general terms with precise 
details to follow. Roughly speaking, both create and delete run at 
around 150 nanoseconds per operation, and do not appear to degrade 
significantly as directory size increases into the hundreds of millions. 
As expected, lookup operations are faster, roughly 100 nanoseconds each. 
This is with a modestly specced workstation and a consumer grade SSD, so 
spinning disk seek performance is not yet being measured.

In general, performance numbers obtained so far match HTree at modest 
scale, definitively dominate at higher scales in the millions of files, 
and continue on up into scales orders of magnitude higher than HTree can 
even attempt.

Directory traversal is in file order for Shardmap, compared to hash 
order for HTree, which entails a computationally intensive procedure of 
sorting and caching intermediate search results required for correct 
directory cookie semantics, a clear win for Shardmap. The effect of 
avoiding HTree's inode table thrashing behaviour has not yet been 
measured (this must wait for a kernel implementation) however it is safe 
to assume that this will be a clear win for Shardmap as well.

Implementation

A nearly complete userspace prototype including unit tests is now 
available in the Tux3 repository:

    https://github.com/OGAWAHirofumi/tux3/blob/master/user/devel/shard.c

We encourage interested observers to compile and run this standalone 
code in order to verify our performance claims. It is also worth seeing 
for yourself just how simple this code is.

The prototype currently lacks the following two important elements:

    * The reshard operation. So far not tested, so we cannot speak to
      the performance impact of reshard just yet, other than from
      estimates that indicate it is small.

    * Free record mapping. Likewise, this will add some additional,
      modest update overhead that we have not yet measured, only
      estimated.

To be useful, Shardmap needs a kernel implementation, which we plan to 
defer until after merging with mainline. Scalable directories are 
certainly nice, but not essential for evaluating the fitness of Tux3 as 
a filesystem in the context of personal or light server use. I will 
comment further on the design of the kernel implementation in a later post.

Summary

Shardmap is a new directory index design created expressly for the Tux3
filesystem, but holds promise in application areas beyond that as an 
upgrade to existing filesystems and probably also being applicable to 
database design. Shardmap arguably constitutes a breakthrough in 
performance, scalability and simplicity in the arcane field of directory 
indexing, solving a number of well known and notoriously difficult 
performance problems as it does.

We expect a kernel implementation of Shardmap to land some time in the 
next few months. In the mean time, we are now satisfied with this key 
aspect of the Tux3 design and will turn our attention back to the 
handful of remaining issues that need to be addressed before offering 
Tux3 for mainline kernel merge.

Regards,

Daniel

[1] This arguably indicates a flaw in the classic radix tree design, 
possibly correctable to work better with sparse files.

[2] Maybe we should allow kernel modules to own and operate their own 
virtual address tables, that is another story.
