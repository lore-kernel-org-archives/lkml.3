Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3AUMLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:11:54 -0500
Received: from mail.six-q.net ([176.62.184.14]:59472 "EHLO mail.six-q.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab3AUMLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:11:51 -0500
X-Greylist: delayed 1714 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 07:11:50 EST
Message-ID: <1358768558.8131.38.camel@rybalov.eng.ttk.net>
Subject: memory management in 3.7
From: "Nikolay S." <nowhere@hakkenden.ath.cx>
To: linux-kernel@vger.kernel.org
Date: Mon, 21 Jan 2013 15:42:38 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Sender-Verify: SUCCEEDED (sender exists & accepts mail)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello there,

I have recently upgraded from 3.2 to 3.7.3, and I am seeing, that the
behavior of kswapd is strange at least.

The machine is core2duo e7200 with 4G RAM, running 3.7.3 kernel. It has
compaction and THP (always) enabled.

The machine is serving files over the network, so it is constantly under
memory pressure from page cache. The network is slow, and average disk
read rate is between 2 and 8 megabytes per second.

In normal state, when page cache is filled, the free memory (according
to free and vmstat) is fluctuating between 100 and 150 megabytes, with
kswapd stepping in at 100M, quickly freeing to 150M and going to sleep
again.

On 3.7.3, after several hours after page cache is filled, kswapd enters
permanent D-state, with free memory keeping around 150M (high watermark,
I presume?). I have captured diffs for /proc/vmstat:

$ ./diffshow 5
----8<----
nr_free_pages:			38327 -> 38467 (140)
nr_active_anon:			110014 -> 110056 (42)
nr_inactive_file:		526153 -> 526297 (144)
nr_active_file:			98802 -> 98864 (62)
nr_anon_pages:			103475 -> 103512 (37)
nr_file_pages:			627957 -> 628160 (203)
nr_dirty:			15 -> 17 (2)
nr_page_table_pages:		2142 -> 2146 (4)
nr_kernel_stack:		251 -> 253 (2)
nr_dirtied:			1169312 -> 1169317 (5)
nr_written:			1211979 -> 1211982 (3)
nr_dirty_threshold:		159540 -> 159617 (77)
nr_dirty_background_threshold:	79770 -> 79808 (38)
pgpgin:				564650577 -> 564673241 (22664)
pgpgout:			5117612 -> 5117668 (56)
pgalloc_dma32:			105487556 -> 105491067 (3511)
pgalloc_normal:			84026173 -> 84029309 (3136)
pgfree:				190134573 -> 190141394 (6821)
pgactivate:			2750244 -> 2750283 (39)
pgfault:			67214984 -> 67216222 (1238)
pgsteal_kswapd_dma32:		45793109 -> 45795077 (1968)
pgsteal_kswapd_normal:		61391466 -> 61394464 (2998)
pgscan_kswapd_dma32:		45812628 -> 45814596 (1968)
pgscan_kswapd_normal:		61465283 -> 61468281 (2998)
slabs_scanned:			30783104 -> 30786432 (3328)
pageoutrun:			2936967 -> 2937033 (66)

vmstat:
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  1 296924 153064   6936 2479664    0    0  5408     0 11711 1350  1  2 44 53
 0  1 296924 152448   6928 2480048    0    0  6760     0 9723 1127  1  4 47 48
 0  1 296924 152948   6916 2479464    0    0  3512    16 10392 1231  1  2 48 49
 0  1 296924 153616   6916 2478804    0    0  2724     0 10279 1078  0  2 48 49
 0  1 296924 152972   6916 2480132    0    0  3584     0 11289 1252  1  3 49 48
 0  1 296924 155348   6916 2478396    0    0  6472     0 11285 1132  1  2 45 53
 0  1 296924 152988   6916 2481024    0    0  5112    20 10039 1257  0  2 46 52
 0  1 296924 152968   6916 2481016    0    0  3244     0 9586 1127  1  3 46 51
 0  1 296924 153500   6916 2481196    0    0  3516     0 10899 1127  1  1 48 49
 0  1 296924 152860   6916 2481688    0    0  4240     0 10418 1245  1  3 47 49
 0  2 296924 153016   6912 2478584    0    0  5632     0 12136 1516  2  3 46 49
 0  2 296924 153292   6912 2480984    0    0  4668     0 10872 1248  1  2 49 48
 0  1 296924 152420   6916 2481844    0    0  4764    56 11236 1402  1  3 45 51
 0  1 296924 152652   6916 2481204    0    0  4628     0 9422 1208  0  3 46 51

buddyinfo:
$ cat /proc/buddyinfo; sleep 1; cat /proc/buddyinfo 
Node 0, zone      DMA      0      0      0      1      2      1      1      0      1      1      3 
Node 0, zone    DMA32    515    205    242    201   1384    116     21      8      1      0      0 
Node 0, zone   Normal   1779      0      0     18     11      3      1      3      0      0      0 
Node 0, zone      DMA      0      0      0      1      2      1      1      0      1      1      3 
Node 0, zone    DMA32    480    197    227    176   1384    116     21      8      1      0      0 
Node 0, zone   Normal   1792      9      0     18     11      3      1      3      0      0      0

Also from time to time situation switches, where free memory is fixed at
some random point, fluctuating around this values at +-1 megabyte. 
There is vmstat:
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0 296480 381052   9732 2481324    1    2  2022    19   45   44  1  2 81 16
 0  0 296480 382040   9732 2481180    0    0  2324     0 6505  825  1  2 96  1
 0  0 296480 382500   9732 2481060    0    0  3824     0 5941 1046  1  2 96  1
 0  0 296480 382092   9740 2480976    0    0  2048    16 7701  862  0  2 97  1
 0  0 296480 382160   9740 2481896    0    0  5008     0 6443 1017  1  2 93  5
 0  0 296480 382484   9740 2481668    0    0  2764     0 6972  799  0  2 97  1
 0  0 296480 381912   9740 2481620    0    0  3780     0 7632 1036  1  2 96  1
 0  0 296480 382240   9744 2481632    0    0  2796     0 7533  981  1  2 95  3
 1  0 296480 382372   9748 2481756    0    0  2940     0 6565 1048  2  2 95  2
 0  0 296480 383064   9748 2480320    0    0  5980     0 6352  979  0  3 92  5
 0  0 296480 381380   9748 2481752    0    0  2732     0 6322  999  1  2 96  1
 0  0 296480 381640   9748 2481992    0    0  2468     0 5640  849  0  2 97  2
 0  0 296480 381684   9748 2481856    0    0  2760     0 7064  944  2  2 95  1
 0  0 296480 381908   9748 2481664    0    0  2608     0 6797  952  0  2 94  4
 0  0 296480 384024   9748 2479424    0    0  4804     0 6342 2767  1  2 94  4
 0  0 296480 381948   9748 2481080    0    0  1868     0 6428  803  0  2 97  2
 0  0 296480 382088   9748 2481524    0    0  3252     0 6464  990  1  1 98  1
 0  0 296480 381884   9748 2481816    0    0  2892     0 7880  858  1  2 94  3
 0  0 296480 382120   9748 2481848    0    0  2500     0 6207  905  1  1 96  2
 0  1 296480 381976   9748 2479876    0    0  5188     0 6691  908  1  2 94  4
 0  0 296480 381708   9748 2481584    0    0  2692     0 7904 1030  1  2 94  3
 0  0 296480 382196   9748 2481704    0    0  2092     0 6715  722  1  1 97  1


The /proc/vmstat diff is like this:

$ ./diffshow 5
----8<----
nr_free_pages:			94999 -> 95630 (631)
nr_inactive_anon:		47076 -> 47196 (120)
nr_inactive_file:		347048 -> 347080 (32)
nr_active_file:			270128 -> 270462 (334)
nr_file_pages:			619886 -> 620314 (428)
nr_dirty:			10 -> 109 (99)
nr_kernel_stack:		248 -> 249 (1)
nr_isolated_file:		0 -> 10 (10)
nr_dirtied:			1147486 -> 1147659 (173)
nr_written:			1189947 -> 1190013 (66)
nr_dirty_threshold:		168770 -> 168974 (204)
nr_dirty_background_threshold:	84385 -> 84487 (102)
pgpgin:				528729753 -> 528750521 (20768)
pgpgout:			5013688 -> 5014216 (528)
pswpin:				77715 -> 77827 (112)
pgalloc_dma32:			95912002 -> 95912631 (629)
pgalloc_normal:			82241808 -> 82247860 (6052)
pgfree:				178827810 -> 178834939 (7129)
pgactivate:			2644761 -> 2645104 (343)
pgfault:			63365808 -> 63369261 (3453)
pgmajfault:			23571 -> 23591 (20)
pgsteal_kswapd_normal:		60067802 -> 60072006 (4204)
pgscan_kswapd_normal:		60141548 -> 60145753 (4205)
slabs_scanned:			28914432 -> 28915456 (1024)
kswapd_low_wmark_hit_quickly:	589343 -> 589376 (33)
kswapd_high_wmark_hit_quickly:	763703 -> 763752 (49)
pageoutrun:			2852120 -> 2852305 (185)
compact_blocks_moved:		10852682 -> 10852847 (165)
compact_pagemigrate_failed:	39862700 -> 39865324 (2624)

kswapd is stuck on normal zone!

Also there is raw vmstat:
nr_free_pages 95343
nr_inactive_anon 47196
nr_active_anon 114110
nr_inactive_file 348142
nr_active_file 272638
nr_unevictable 552
nr_mlock 552
nr_anon_pages 100386
nr_mapped 6158
nr_file_pages 623530
nr_dirty 0
nr_writeback 0
nr_slab_reclaimable 21356
nr_slab_unreclaimable 15570
nr_page_table_pages 2045
nr_kernel_stack 244
nr_unstable 0
nr_bounce 0
nr_vmscan_write 149405
nr_vmscan_immediate_reclaim 13896
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 4
nr_shmem 48
nr_dirtied 1147666
nr_written 1190129
nr_anon_transparent_hugepages 116
nr_free_cma 0
nr_dirty_threshold 169553
nr_dirty_background_threshold 84776
pgpgin 529292001
pgpgout 5014788
pswpin 77827
pswpout 148890
pgalloc_dma 0
pgalloc_dma32 95940824
pgalloc_normal 82395157
pgalloc_movable 0
pgfree 179010711
pgactivate 2647284
pgdeactivate 2513412
pgfault 63427189
pgmajfault 23606
pgrefill_dma 0
pgrefill_dma32 1915983
pgrefill_normal 430939
pgrefill_movable 0
pgsteal_kswapd_dma 0
pgsteal_kswapd_dma32 39927548
pgsteal_kswapd_normal 60180622
pgsteal_kswapd_movable 0
pgsteal_direct_dma 0
pgsteal_direct_dma32 14062458
pgsteal_direct_normal 1894412
pgsteal_direct_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_dma32 39946808
pgscan_kswapd_normal 60254407
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 14260652
pgscan_direct_normal 1895350
pgscan_direct_movable 0
pgscan_direct_throttle 0
pginodesteal 25301
slabs_scanned 28931968
kswapd_inodesteal 26119
kswapd_low_wmark_hit_quickly 591050
kswapd_high_wmark_hit_quickly 766006
kswapd_skip_congestion_wait 15
pageoutrun 2858733
allocstall 156938
pgrotated 161518
compact_blocks_moved 10860505
compact_pages_moved 411760
compact_pagemigrate_failed 39987369
compact_stall 29399
compact_fail 23718
compact_success 5681
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 6416
unevictable_pgs_scanned 0
unevictable_pgs_rescued 5337
unevictable_pgs_mlocked 6672
unevictable_pgs_munlocked 6120
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
thp_fault_alloc 41
thp_fault_fallback 302
thp_collapse_alloc 507
thp_collapse_alloc_failed 3704
thp_split 111

Buddyinfo:
$ cat /proc/buddyinfo; sleep 1; cat /proc/buddyinfo 
Node 0, zone      DMA      0      0      0      1      2      1      1      0      1      1      3 
Node 0, zone    DMA32  29527  26916    489    221     40      5      0      0      0      0      0 
Node 0, zone   Normal   3158      0      0      2      1      1      1      1      0      0      0 
Node 0, zone      DMA      0      0      0      1      2      1      1      0      1      1      3 
Node 0, zone    DMA32  29527  26909    489    211     41      5      0      0      0      0      0 
Node 0, zone   Normal   2790     29      0      8      1      1      1      1      0      0      0 

Zoneinfo:
$ cat /proc/zoneinfo 
Node 0, zone      DMA
  pages free     3976
        min      64
        low      80
        high     96
        scanned  0
        spanned  4080
        present  3912
    nr_free_pages 3976
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_vmscan_immediate_reclaim 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
    nr_dirtied   0
    nr_written   0
    nr_anon_transparent_hugepages 0
    nr_free_cma  0
        protection: (0, 3503, 4007, 4007)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 8
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 8
  all_unreclaimable: 1
  start_pfn:         16
  inactive_ratio:    1
Node 0, zone    DMA32
  pages free     87395
        min      14715
        low      18393
        high     22072
        scanned  0
        spanned  1044480
        present  896960
    nr_free_pages 87395
    nr_inactive_anon 18907
    nr_active_anon 92242
    nr_inactive_file 325044
    nr_active_file 267577
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 51703
    nr_mapped    4369
    nr_file_pages 593009
    nr_dirty     17
    nr_writeback 0
    nr_slab_reclaimable 14988
    nr_slab_unreclaimable 11515
    nr_page_table_pages 1305
    nr_kernel_stack 133
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 140220
    nr_vmscan_immediate_reclaim 62
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     10
    nr_dirtied   810741
    nr_written   862763
    nr_anon_transparent_hugepages 116
    nr_free_cma  0
        protection: (0, 0, 504, 504)
  pagesets
    cpu: 0
              count: 123
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 29
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  start_pfn:         4096
  inactive_ratio:    5
Node 0, zone   Normal
  pages free     3200
        min      2116
        low      2645
        high     3174
        scanned  0
        spanned  131072
        present  129024
    nr_free_pages 3200
    nr_inactive_anon 25943
    nr_active_anon 24590
    nr_inactive_file 23132
    nr_active_file 10275
    nr_unevictable 552
    nr_mlock     552
    nr_anon_pages 49050
    nr_mapped    2088
    nr_file_pages 35785
    nr_dirty     3
    nr_writeback 0
    nr_slab_reclaimable 2340
    nr_slab_unreclaimable 3926
    nr_page_table_pages 786
    nr_kernel_stack 114
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 9297
    nr_vmscan_immediate_reclaim 13835
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 10
    nr_shmem     38
    nr_dirtied   338110
    nr_written   328638
    nr_anon_transparent_hugepages 0
    nr_free_cma  0
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 152
              high:  186
              batch: 31
  vm stats threshold: 12
    cpu: 1
              count: 172
              high:  186
              batch: 31
  vm stats threshold: 12
  all_unreclaimable: 0
  start_pfn:         1048576
  inactive_ratio:    1

I have tried disabling compaction (1000
> /proc/sys/vm/extdefrag_threshold), and symptoms do change. There is no
kswapd stuck in D, but instead page cache is almost cleaned from time to
time 

I use this simple script to get difference for /proc/vmstat
$ cat diffshow
#!/bin/sh

sleep_int=$1
first_pass=1

while [ 0 ]; do
    echo '----8<----'

    while read a b; do
        if [ $first_pass -eq 0 ]; then
	    eval "diff=\$((b - ${a}_last))"

	    [ $diff -gt 0 ] && \
	    eval "printf \"%s:\t%d -> %d (%d)\n\" $a \$${a}_last $b $diff"
	fi

	eval "${a}_last=$b"
    done < /proc/vmstat

    first_pass=0
    sleep $sleep_int
done

Also I have a piece of code, which can reproduce the first problem with
kswapd in D state on another amd64 system, which has normal zone
artificially limited to the same ratio against dma32 zone. It needs a
large file, which is at least twice as large as system RAM (the larger
the better):
dd if=/dev/zero of=tf bs=1M count=$((1024*8))

Then start smth like this:
./a.out tf 32
and let it run for some time to fill the page cache.

The code will random read the file in fixed chunks at fixed rate in two
"streams": one stream of 1/3 rate will be scattered across the whole
file and mark pages with WILLNEED. Another stream at 2/3 rate is
contained in 1/10 of a file and will not pass any hints.

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <limits.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <sys/time.h>
#include <fcntl.h>

#define ERR(a)	do { printf ("System error in " a ": %d (%s)", errno, strerror (errno)); exit (EXIT_FAILURE); } while (0)
#define READ_CHUNK	16384
#define READ_RATE	(6 * 1024 * 1024)	/* Bytes per second */
#define	GIGA		1000000000

#define min(a,b)	({			\
	typeof(a) __b = (b);			\
	typeof(b) __a = (a);			\
	__a < __b ? __a : __b;			\
})

enum block_type_e {
    BLOCK_HOT,
    BLOCK_COLD,
};

static size_t pagesize;

void my_read_block (int fd, off_t offset, ssize_t size, enum block_type_e blk_type) {
#ifdef USE_MMAP    
    off_t map_start;
    size_t map_size;
    void *map;
#endif
    static char buf[READ_CHUNK];
    ssize_t to_read = size;
    
    offset *= size;

#ifdef USE_MMAP
    map_size = size / pagesize * pagesize;
    if (map_size < size) map_size += pagesize;

    map_start = offset / pagesize * pagesize;
    offset -= map_start;

    map = mmap (NULL, map_size, PROT_READ, MAP_PRIVATE, fd, map_start);
    if (!map) ERR ("mmap");
#else
    lseek (fd, offset, SEEK_SET);
#endif

    for (to_read = size; to_read > 0; to_read -= READ_CHUNK, offset += READ_CHUNK) {
#ifdef USE_MMAP	
	memcpy (buf, (char*) map + offset, min (READ_CHUNK, to_read));
#else
        if (blk_type == BLOCK_COLD)
	    posix_fadvise (fd, offset, min (READ_CHUNK, to_read), POSIX_FADV_WILLNEED);

	read (fd, buf, min (READ_CHUNK, to_read));
#endif
    }

#ifdef USE_MMAP
    munmap (map, map_size);
#endif
}

int main (int argc, char *argv[]) {
    int fd, ret, i = 0;
    char *b, *file;
    struct timespec now, read_next = {};
    size_t read_block;
    struct stat f_stat;
    off_t file_size_blocks;

    if (argc < 3) ERR ("Not enough arguments");
    file = argv[1];
    read_block = atol (argv[2]) * 1024;

    pagesize = sysconf (_SC_PAGESIZE);
    if (pagesize <= 1) pagesize = 4096;

    clock_gettime (CLOCK_MONOTONIC, &now);

    fd = open ("/dev/urandom", O_RDONLY);
    if (fd < 0)
        ERR ("open /dev/urandom");

    b = (char*) malloc (64);
    if ((ret = read (fd, b, 64)) > 0) {
        char *state = initstate (now.tv_nsec, b, ret);
	if (!state) ERR ("initstate");
	setstate (state);
    }

    free (b);
    close (fd);

    fd = open (file, O_RDONLY);
    if (fd < 0)
        ERR ("open");
    
    if (fstat (fd, &f_stat) != 0)
        ERR ("stat");

    file_size_blocks = (unsigned long long) f_stat.st_size / read_block;
    printf ("File has %llu blocks of size %ld\n", (unsigned long long) file_size_blocks, read_block);

    clock_gettime (CLOCK_MONOTONIC, &now);

    while (1) {
        ssize_t read_off;
	enum block_type_e read_type;

        if ((i = (i+1) % 3)) {
	    read_type = BLOCK_COLD;
	    read_off = (unsigned long long) random() * file_size_blocks / 
	                         (unsigned long long) RAND_MAX;
        } else {
	    read_type = BLOCK_HOT;
	    read_off = (unsigned long long) random() * file_size_blocks /
	                                     (unsigned long long) RAND_MAX / 10;
	}
    
	my_read_block (fd, read_off, read_block, read_type);

	read_next.tv_nsec = now.tv_nsec + GIGA / READ_RATE * read_block;
	read_next.tv_sec = now.tv_sec + read_next.tv_nsec / GIGA;
	read_next.tv_nsec %= GIGA;

	while (clock_nanosleep (CLOCK_MONOTONIC, TIMER_ABSTIME, &read_next, NULL) != 0);
	clock_gettime (CLOCK_MONOTONIC, &now);
    }

    return 0;
}


