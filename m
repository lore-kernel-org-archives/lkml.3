Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3KULoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:44:14 -0500
Received: from mail-am1lp0012.outbound.protection.outlook.com ([213.199.154.12]:38953
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754168Ab3KULoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:44:12 -0500
X-Greylist: delayed 956 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 06:44:11 EST
Message-ID: <528DEE48.4000907@zynstra.com>
Date: Thu, 21 Nov 2013 11:28:08 +0000
From: James Dingwall <james.dingwall@zynstra.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:25.0) Gecko/20100101 Firefox/25.0 SeaMonkey/2.22.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: Kernel 3.11 / 3.12 OOM killer and Xen ballooning
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [157.56.248.165]
X-ClientProxiedBy: AMSPR03CA008.eurprd03.prod.outlook.com (10.242.77.146) To
 AMXPR03MB103.eurprd03.prod.outlook.com (10.242.87.26)
X-Forefront-PRVS: 0037FD6480
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(164054003)(199002)(189002)(56776001)(81342001)(83322001)(76482001)(74502001)(4396001)(80316001)(81686001)(87976001)(64126003)(76786001)(74366001)(74706001)(76176001)(69226001)(49866001)(85306002)(47736001)(83506001)(47446002)(46102001)(50466002)(74662001)(81816001)(19580395003)(47976001)(80976001)(31966008)(77096001)(50986001)(63696002)(47776003)(79102001)(54316002)(33656001)(66066001)(81542001)(80022001)(74876001)(59896001)(76796001)(56816003)(42186004)(59766001)(77982001)(36756003)(54356001)(83072001)(53806001)(23676002)(51856001)(7744002);DIR:OUT;SFP:;SCL:1;SRVR:AMXPR03MB103;H:AMXPRD0410HT005.eurprd04.prod.outlook.com;CLIP:157.56.248.165;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: zynstra.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since 3.11 I have noticed that the OOM killer quite frequently triggers 
in my Xen guest domains which use ballooning to increase/decrease their 
memory allocation according to their requirements.  One example domain I 
have has a maximum memory setting of ~1.5Gb but it usually idles at 
~300Mb, it is also configured with 2Gb swap which is almost 100% free.

# free
              total       used       free     shared    buffers cached
Mem:        272080     248108      23972          0 1448      63064
-/+ buffers/cache:     183596      88484
Swap:      2097148          8    2097140

There is plenty of available free memory in the hypervisor to balloon to 
the maximum size:
# xl info | grep free_mem
free_memory            : 14923

An example trace from the oom killer in 3.12 is added below.  So far I 
have not been able to reproduce this at will so it is difficult to start 
bisecting it to see if a particular change introduced this.  However it 
does seem that the behaviour is wrong because a) ballooning could give 
the guest more memory, b) there is lots of swap available which could be 
used as a fallback.

If other information could help or there are more tests that I could run 
then please let me know.

Thanks,
James




[473233.777271] emerge invoked oom-killer: gfp_mask=0x280da, order=0, 
oom_score_adj=0
[473233.777279] CPU: 0 PID: 22159 Comm: emerge Tainted: G W    3.12.0 #80
[473233.777282]  ffff88000599f6f8 ffff8800117bda58 ffffffff81489a80 
ffff88004760e8e8
[473233.777286]  ffff88000599f1c0 ffff8800117bdaf8 ffffffff81487577 
ffff8800117bdaa8
[473233.777289]  ffffffff810f8c0f ffff8800117bda88 ffffffff81006dc8 
ffff8800117bda98
[473233.777293] Call Trace:
[473233.777305]  [<ffffffff81489a80>] dump_stack+0x46/0x58
[473233.777310]  [<ffffffff81487577>] dump_header.isra.9+0x6d/0x1cc
[473233.777315]  [<ffffffff810f8c0f>] ? super_cache_count+0xa8/0xb8
[473233.777321]  [<ffffffff81006dc8>] ? xen_clocksource_read+0x20/0x22
[473233.777324]  [<ffffffff81006ea9>] ? xen_clocksource_get_cycles+0x9/0xb
[473233.777328]  [<ffffffff8148f336>] ? 
_raw_spin_unlock_irqrestore+0x47/0x62
[473233.777333]  [<ffffffff812915d3>] ? ___ratelimit+0xcb/0xe8
[473233.777338]  [<ffffffff810b2aa7>] oom_kill_process+0x70/0x2fd
[473233.777343]  [<ffffffff81048775>] ? has_ns_capability_noaudit+0x12/0x19
[473233.777346]  [<ffffffff8104878e>] ? has_capability_noaudit+0x12/0x14
[473233.777349]  [<ffffffff810b31c6>] out_of_memory+0x31b/0x34e
[473233.777353]  [<ffffffff810b72f0>] __alloc_pages_nodemask+0x65b/0x792
[473233.777358]  [<ffffffff810e3c1b>] alloc_pages_vma+0xd0/0x10c
[473233.777361]  [<ffffffff81003f69>] ? 
__raw_callee_save_xen_pmd_val+0x11/0x1e
[473233.777365]  [<ffffffff810cf685>] handle_mm_fault+0x6d4/0xd54
[473233.777371]  [<ffffffff81037f40>] __do_page_fault+0x3d8/0x437
[473233.777374]  [<ffffffff81006dc8>] ? xen_clocksource_read+0x20/0x22
[473233.777378]  [<ffffffff810115d2>] ? sched_clock+0x9/0xd
[473233.777382]  [<ffffffff810676c7>] ? sched_clock_local+0x12/0x75
[473233.777386]  [<ffffffff810a44b4>] ? __acct_update_integrals+0xb4/0xbf
[473233.777389]  [<ffffffff810a4827>] ? acct_account_cputime+0x17/0x19
[473233.777392]  [<ffffffff81067bc0>] ? account_user_time+0x67/0x92
[473233.777395]  [<ffffffff810680b3>] ? vtime_account_user+0x4d/0x52
[473233.777398]  [<ffffffff81037fd8>] do_page_fault+0x1a/0x5a
[473233.777401]  [<ffffffff8148f9d8>] page_fault+0x28/0x30
[473233.777403] Mem-Info:
[473233.777405] Node 0 DMA per-cpu:
[473233.777408] CPU    0: hi:    0, btch:   1 usd:   0
[473233.777409] CPU    1: hi:    0, btch:   1 usd:   0
[473233.777411] CPU    2: hi:    0, btch:   1 usd:   0
[473233.777412] CPU    3: hi:    0, btch:   1 usd:   0
[473233.777413] Node 0 DMA32 per-cpu:
[473233.777415] CPU    0: hi:  186, btch:  31 usd: 103
[473233.777417] CPU    1: hi:  186, btch:  31 usd: 110
[473233.777419] CPU    2: hi:  186, btch:  31 usd: 175
[473233.777420] CPU    3: hi:  186, btch:  31 usd: 182
[473233.777421] Node 0 Normal per-cpu:
[473233.777423] CPU    0: hi:    0, btch:   1 usd:   0
[473233.777424] CPU    1: hi:    0, btch:   1 usd:   0
[473233.777426] CPU    2: hi:    0, btch:   1 usd:   0
[473233.777427] CPU    3: hi:    0, btch:   1 usd:   0
[473233.777433] active_anon:35740 inactive_anon:33812 isolated_anon:0
  active_file:4672 inactive_file:11607 isolated_file:0
  unevictable:0 dirty:4 writeback:0 unstable:0
  free:2067 slab_reclaimable:3583 slab_unreclaimable:3524
  mapped:3329 shmem:324 pagetables:2003 bounce:0
  free_cma:0
[473233.777435] Node 0 DMA free:4200kB min:60kB low:72kB high:88kB 
active_anon:264kB inactive_anon:456kB active_file:140kB 
inactive_file:340kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:15996kB managed:6176kB mlocked:0kB dirty:0kB 
writeback:0kB mapped:100kB shmem:0kB slab_reclaimable:96kB 
slab_unreclaimable:112kB kernel_stack:24kB pagetables:24kB unstable:0kB 
bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:33270 
all_unreclaimable? yes
[473233.777443] lowmem_reserve[]: 0 1036 1036 1036
[473233.777447] Node 0 DMA32 free:4060kB min:4084kB low:5104kB 
high:6124kB active_anon:41256kB inactive_anon:33128kB active_file:8544kB 
inactive_file:14312kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:1163264kB managed:165780kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:6428kB shmem:604kB 
slab_reclaimable:9800kB slab_unreclaimable:12908kB kernel_stack:1832kB 
pagetables:5924kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:152386 all_unreclaimable? yes
[473233.777454] lowmem_reserve[]: 0 0 0 0
[473233.777457] Node 0 Normal free:8kB min:0kB low:0kB high:0kB 
active_anon:101440kB inactive_anon:101664kB active_file:10004kB 
inactive_file:31776kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:393216kB managed:256412kB mlocked:0kB 
dirty:16kB writeback:0kB mapped:6788kB shmem:692kB 
slab_reclaimable:4436kB slab_unreclaimable:1076kB kernel_stack:136kB 
pagetables:2064kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:368809 all_unreclaimable? yes
[473233.777464] lowmem_reserve[]: 0 0 0 0
[473233.777467] Node 0 DMA: 41*4kB (U) 0*8kB 0*16kB 0*32kB 1*64kB (R) 
1*128kB (R) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 1*2048kB (R) 0*4096kB = 
4196kB
[473233.777480] Node 0 DMA32: 1015*4kB (U) 0*8kB 0*16kB 0*32kB 0*64kB 
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4060kB
[473233.777490] Node 0 Normal: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[473233.777498] 5018 total pagecache pages
[473233.777500] 16 pages in swap cache
[473233.777501] Swap cache stats: add 2829330, delete 2829314, find 
344059/481859
[473233.777503] Free swap  = 2096980kB
[473233.777503] Total swap = 2097148kB
[473233.794497] 557055 pages RAM
[473233.794500] 189326 pages reserved
[473233.794501] 544934 pages shared
[473233.794502] 358441 pages non-shared
[473233.794504] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[473233.794523] [ 6597]     0  6597     8156      252 20        0 
   -1000 udevd
[473233.794530] [ 7194]     0  7194     2232      137 10        0 
       0 metalog
[473233.794534] [ 7195]     0  7195     2223       31 10        3 
       0 metalog
[473233.794537] [ 7211]     0  7211     1064       35 8        0 
      0 acpid
[473233.794546] [ 7227]   702  7227     4922      183 14        0 
       0 dbus-daemon
[473233.794553] [ 7427]     0  7427    13630      179 29       15 
       0 rpcbind
[473233.794560] [ 7442]     0  7442    14743      332 32        0 
       0 rpc.statd
[473233.794569] [ 7472]     0  7472     6365      115 17        0 
       0 rpc.idmapd
[473233.794576] [ 7488]     0  7488    43602      349 40        0 
       0 cupsd
[473233.794583] [ 7512]     0  7512    14856      243 30        0 
       0 rpc.mountd
[473233.794592] [ 7552]     0  7552   148819      940 68        0 
       0 automount
[473233.794595] [ 7592]     0  7592    16006      233 32        0 
   -1000 sshd
[473233.794598] [ 7608]     0  7608    87672     2257 128        6 
        0 apache2
[473233.794601] [ 7633]     0  7633   521873      631 56        0 
       0 console-kit-dae
[473233.794604] [ 7713]   106  7713    15453      295 34        2 
       0 nrpe
[473233.794607] [ 7719]   986  7719    91303      798 41        0 
       0 polkitd
[473233.794610] [ 7757]   123  7757     7330      259 17        0 
       0 ntpd
[473233.794613] [ 7845]     0  7845     3583       94 12        0 
       0 master
[473233.794616] [ 7847]   207  7847    17745      311 38        0 
       0 qmgr
[473233.794619] [ 7861] 65534  7861     2101       21 9       19 
      0 rwhod
[473233.794622] [ 7864] 65534  7864     2101       99 9        0 
      0 rwhod
[473233.794625] [ 7876]     0  7876    48582      533 47       19 
       0 smbd
[473233.794628] [ 7881]     0  7881    44277      372 38        0 
       0 nmbd
[473233.794631] [ 7895]     0  7895    48646      621 45       18 
       0 smbd
[473233.794634] [ 7902]     2  7902     1078       39 8        4 
      0 slpd
[473233.794637] [ 7917]     0  7917    38452     1073 28        1 
       0 snmpd
[473233.794640] [ 7945]     0  7945    27552       58 9        0 
      0 cron
[473233.794648] [ 7993]     0  7993   201378     5432 63       39 
       0 nscd
[473233.794658] [ 8064]     0  8064     1060       28 7        0 
      0 agetty
[473233.794664] [ 8065]     0  8065    26507       29 9        0 
      0 agetty
[473233.794667] [ 8066]     0  8066    26507       29 9        0 
      0 agetty
[473233.794670] [ 8067]     0  8067    26507       28 9        0 
      0 agetty
[473233.794673] [ 8068]     0  8068    26507       28 8        0 
      0 agetty
[473233.794678] [ 8069]     0  8069    26507       30 9        0 
      0 agetty
[473233.794686] [ 8070]     0  8070    26507       30 9        0 
      0 agetty
[473233.794693] [ 8071]     0  8071    26507       30 9        0 
      0 agetty
[473233.794701] [ 8072]     0  8072    26507       28 9        0 
      0 agetty
[473233.794708] [ 8316]     0  8316     3736       83 11        6 
       0 ssh-agent
[473233.794712] [ 8341]     0  8341     3390       66 12        7 
       0 gpg-agent
[473233.794716] [ 2878]    81  2878    88431     2552 121        5 
        0 apache2
[473233.794718] [ 2879]    81  2879    88431     2552 121        5 
        0 apache2
[473233.794721] [ 2880]    81  2880    88431     2552 121        5 
        0 apache2
[473233.794724] [ 2881]    81  2881    88431     2552 121        5 
        0 apache2
[473233.794727] [ 2882]    81  2882    88431     2552 121        5 
        0 apache2
[473233.794734] [ 3523]    81  3523    88431     2552 121        5 
        0 apache2
[473233.794737] [30259]  1000 30259     3736      118 11        0 
       0 ssh-agent
[473233.794741] [30284]  1000 30284     3390      141 12        0 
       0 gpg-agent
[473233.794745] [21263]   207 21263    17703      771 39        1 
       0 pickup
[473233.794748] [21663]     0 21663    30743      228 16        0 
       0 cron
[473233.794751] [21665]     0 21665     2980      392 12        0 
       0 gentoosync.sh
[473233.794755] [22158]     0 22158     3181      273 12        0 
       0 sendmail
[473233.794757] [22159]     0 22159    77646    54920 158        0 
        0 emerge
[473233.794760] [22160]     0 22160     1068       85 8        0 
      0 tail
[473233.794764] [22161]     0 22161     3173      277 11        0 
       0 postdrop
[473233.794768] Out of memory: Kill process 22159 (emerge) score 57 or 
sacrifice child
[473233.794771] Killed process 22159 (emerge) total-vm:310584kB, 
anon-rss:215840kB, file-rss:3840kB

