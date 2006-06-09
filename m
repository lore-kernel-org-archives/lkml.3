Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbaE2QJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:09:05 -0400
Received: from mx2.netorek.fi ([213.157.84.84]:41964 "EHLO mx2.netorek.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103AbaE2QFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:05:18 -0400
Date: Thu, 8 Jun 2006 20:34:10 -0400
From: Maurice Volaski <mvolaski@aecom.yu.edu>
To: linux-kernel@vger.kernel.org, drbd-user@linbit.com
Subject: [DRBD-user] Kernel 2.6.17-rc5 under amd64 may be hanging I/O, [Was] Re: [Q] What would cause fsck running on a drbd device to just stop?
Message-Id: <20140529153601.B8BF1205E70@mx2.netorek.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that kernel 2.6.17-rc5 under amd64 may be hanging I/O 
processes spontaneously at random.

Our setup here uses drbd (ver. 0.7.19), which is a network RAID 
kernel module, and initially I was fscking (ext3) filesystems, which 
are on drbd devices, and the fsck just stopped spontaneously on the 
two of them.

Today, I tried copying a directory on the command line with cp -a on 
this computer (on a drbd-managed device) and then in mid-copy I tried 
to abort the process with control-C. It did not abort. I tried 
killing it with kill and then with kill -9. It turns out that the 
process had died, but is still left in ps.

Just by happenstance,

Anyway, I tried bringing down the peer and bringing it back up and it stalled.

I also had an emerge sync (i.e., the Gentoo update mechanism) going 
and it too got stuck, but it doesn't, or at least shouldn't affect 
drbd disks, implying this is not a drbd bug, but a kernel bug.


>* what are the numbers in /proc/drbd

This is how it appears long after the copy hang and I stopped and 
just restarted drbd on the peer. The output from then hanging 
computer:


version: 0.7.19 (api:78/proto:74)
SVN Revision: 2212 build by root@thewarehouse1, 2006-05-28 17:54:59
  0: cs:SyncSource st:Primary/Secondary ld:Consistent
     ns:844864 nr:0 dw:325684 dr:940453 al:200 bm:123 lo:0 pe:0 ua:13 ap:0
         [===================>] sync'ed:100.0% (52/52)K
         stalled
  1: cs:SyncSource st:Primary/Secondary ld:Consistent
     ns:41686716 nr:0 dw:41166664 dr:57457996 al:76392 bm:94 lo:0 pe:0 ua:0 ap:0
         [===================>] sync'ed:100.0% (120/120)K
         stalled
  2: cs:SyncSource st:Primary/Secondary ld:Consistent
     ns:45970636 nr:0 dw:45451468 dr:27302312 al:45571 bm:63 lo:0 pe:0 ua:0 ap:0
         [===================>] sync'ed:100.0% (1020/1020)K
         stalled
  3: cs:PausedSyncS st:Primary/Secondary ld:Consistent
     ns:284957716 nr:0 dw:284450048 dr:251121904 al:266659 bm:759 lo:0 
pe:0 ua:0 ap:0
  4: cs:WFReportParams st:Primary/Unknown ld:Consistent
     ns:92534448 nr:0 dw:133197016 dr:64860944 al:157353 bm:21176 
lo:19 pe:0 ua:0 ap:0
  5: cs:WFReportParams st:Primary/Unknown ld:Consistent
     ns:64605420 nr:0 dw:64085232 dr:54424576 al:132822 bm:121 lo:6 
pe:0 ua:0 ap:0
  6: cs:Connected st:Primary/Secondary ld:Consistent
     ns:88661276 nr:0 dw:88141084 dr:43618112 al:123587 bm:122 lo:0 
pe:0 ua:0 ap:0
  7: cs:PausedSyncS st:Primary/Secondary ld:Consistent
     ns:79213408 nr:0 dw:78693368 dr:42392908 al:184445 bm:128 lo:0 
pe:0 ua:0 ap:0
  8: cs:WFReportParams st:Primary/Unknown ld:Consistent
     ns:114288948 nr:0 dw:114035536 dr:113012216 al:80028 bm:2102 lo:2 
pe:0 ua:0 ap:0



>* get the wchan of the stuck processes
>   via top, or ps -eo pid,wchan:40,comm, or cat /proc/<pid>/wchan
>     (not only the fsck, but everything that may be
>     related, so fs-related kernel threads, vm-related
>     kernel threads, drbd-related kernel-threads).

  PID WCHAN                                    COMMAND         STAT
     1 select                                   init            Ss
     2 migration_thread                         migration/0     S
     3 ksoftirqd                                ksoftirqd/0     SN
     4 watchdog                                 watchdog/0      S
     5 migration_thread                         migration/1     S
     6 ksoftirqd                                ksoftirqd/1     SN
     7 watchdog                                 watchdog/1      S
     8 worker_thread                            events/0        S<
     9 worker_thread                            events/1        S<
    10 worker_thread                            khelper         S<
    11 worker_thread                            kthread         S<
    16 worker_thread                            kblockd/0       S<
    17 worker_thread                            kblockd/1       S<
    18 serio_thread                             kseriod         S<
   108 drbd_al_begin_io                         kswapd0         D
   109 drbd_al_begin_io                         kswapd1         D
   110 worker_thread                            aio/0           S<
   111 worker_thread                            aio/1           S<
   746 scsi_error_handler                       scsi_eh_0       S<
   750 worker_thread                            ata/0           S<
   751 worker_thread                            ata/1           S<
   774 worker_thread                            kpsmoused       S<
  1380 worker_thread                            kmirrord        S<
  1918 scsi_error_handler                       scsi_eh_1       S<
  2136 kjournald                                kjournald       S<
  2801 select                                   udevd           S<s
  3842 kjournald                                kjournald       S<
  3844 kjournald                                kjournald       S<
  5638 sys_poll                                 metalog         Ss
  5639 syslog                                   metalog         S
  6597 select                                   sshd            Ss
  6767 sk_wait_data                             drbd0_receiver  S
  6769 sk_wait_data                             drbd1_receiver  S
  6771 sk_wait_data                             drbd7_receiver  S
  6773 sk_wait_data                             drbd2_receiver  S
  6775 sk_wait_data                             drbd3_receiver  S
  6777 drbd_determin_dev_size                   drbd8_receiver  D
  6779 drbd_determin_dev_size                   drbd4_receiver  D
  6781 drbd_determin_dev_size                   drbd5_receiver  D
  6783 sk_wait_data                             drbd6_receiver  S
  7013 sys_poll                                 heartbeat       SLs
  7035 pipe_wait                                heartbeat       SL
  7036 sys_poll                                 heartbeat       SL
  7037 skb_recv_datagram                        heartbeat       SL
  7184 wait                                     mon             S
  7327 skb_recv_datagram                        portsentry      Ss
  7329 skb_recv_datagram                        portsentry      Ss
  7444 select                                   master          Ss
  7459 select                                   qmgr            S
  7589 hrtimer_nanosleep                        cron            Ss
  7717 read_chan                                agetty          Ss+
  7718 read_chan                                agetty          Ss+
  7719 read_chan                                agetty          Ss+
  7720 read_chan                                agetty          Ss+
  7721 read_chan                                agetty          Ss+
  7722 read_chan                                agetty          Ss+
  8923 kjournald                                kjournald       S<
  8971 kjournald                                kjournald       S<
  9019 kjournald                                kjournald       S<
  9067 kjournald                                kjournald       S<
  9115 drbd_al_begin_io                         kjournald       D<
  9163 kjournald                                kjournald       S<
  9211 kjournald                                kjournald       S<
  9259 kjournald                                kjournald       S<
  9307 drbd_al_begin_io                         kjournald       D<
  9438 select                                   atalkd          S
  9544 select                                   smbd            Ss
  9548 pause                                    smbd            S
  9554 select                                   nmbd            Ss
  9688 select                                   mysqld          Ssl
  9901 select                                   cnid_metad      S
  9910 select                                   afpd            S
11332 compat_sys_nanosleep                     retroclient     Ss
11333 sys_poll                                 retroclient     S
11335 compat_sys_nanosleep                     retroclient     S
11336 inet_csk_accept                          retroclient     S
11337 skb_recv_datagram                        retroclient     S
11344 inet_csk_accept                          retroclient     S
11345 skb_recv_datagram                        retroclient     S
11352 inet_csk_accept                          retroclient     S
11353 skb_recv_datagram                        retroclient     S
11360 inet_csk_accept                          retroclient     S
11365 compat_sys_nanosleep                     retroclient     S
11908 select                                   cnid_dbd        S
  8270 select                                   smbd            S
10289 drbd_al_begin_io                         smbd            D
31891 select                                   smbd            S
29010 drbd_al_begin_io                         smbd            D
24530 select                                   smbd            S
32250 pdflush                                  pdflush         S
19751 drbd_al_begin_io                         pdflush         D
  3856 sk_wait_data                             afpd            S
  8543 select                                   smbd            S
11364 sk_wait_data                             afpd            S
27917 sk_wait_data                             afpd            S
27918 select                                   cnid_dbd        S
22538 select                                   smbd            S
12830 select                                   smbd            S
17962 select                                   smbd            S
23331 select                                   smbd            S
28361 select                                   smbd            S
28411 wait                                     bash            S
  3404 select                                   smbd            S
13660 select                                   smbd            S
23339 sk_wait_data                             afpd            S
27168 kjournald                                kjournald       S<
25449 select                                   smbd            S
28328 select                                   smbd            S
32490 select                                   apache2         Ss
24761 skb_recv_datagram                        apache2         S
24764 inet_csk_accept                          apache2         S
24765 inet_csk_accept                          apache2         S
24766 inet_csk_accept                          apache2         S
24767 inet_csk_accept                          apache2         S
24768 inet_csk_accept                          apache2         S
  2091 select                                   smbd            S
10197 select                                   smbd            S
10832 select                                   smbd            S
15513 select                                   smbd            S
19215 select                                   smbd            S
19585 select                                   smbd            S
19761 drbd_al_begin_io                         smbd            D
21619 inet_csk_accept                          apache2         S
21620 inet_csk_accept                          apache2         S
30680 select                                   smbd            S
31724 select                                   smbd            S
32105 sk_wait_data                             afpd            S
  8343 select                                   smbd            S
17100 sk_wait_data                             afpd            S
14374 compat_sys_nanosleep                     retroclient     S
14376 get_write_access                         retropds.23     D
14397 pipe_wait                                retroclient     S
27942 pipe_wait                                cron            S
27943 wait                                     bash            Ss
27944 wait                                     run-crons       S
27973 wait                                     hotbackup_daily S
27976 wait                                     hotbackup_daily S
28053 pipe_wait                                sendmail        S
28056 unix_stream_recvmsg                      postdrop        S
28058 sync_buffer                              mv              D
28509 get_write_access                         find            D
28512 pipe_wait                                sort            S
28514 pipe_wait                                sed             S
12803 wait                                     slocate         S
12804 vfs_readdir                              updatedb        DN
28845 drbd_al_begin_io                         smbd            D
  2145 drbd_al_begin_io                         smbd            D
  2885 select                                   smbd            S
  3571 select                                   smbd            S
  5313 select                                   smbd            S
  5417 drbd_al_begin_io                         smbd            D
  5444 drbd_al_begin_io                         mon             D
  5468 drbd_al_begin_io                         smbd            D
  6218 wait                                     bash            S
  6237 drbd_al_begin_io                         cp              D
  6332 wait                                     bash            S
  6340 vfs_unlink                               rm              D
  6390 select                                   smbd            S
  6499 vfs_readdir                              ls              D
  6595 sk_wait_data                             afpd            S
  6947 log_wait_commit                          cnid_dbd        D
  7084 sk_wait_data                             afpd            S
  7136 drbd_al_begin_io                         smbd            D
  7149 select                                   smbd            S
  7213 drbd_al_begin_io                         afpd            D
  7754 drbd_al_begin_io                         smbd            D
  7757 drbd_al_begin_io                         afpd            D
  7758 drbd_al_begin_io                         smbd            D
  7764 select                                   smbd            S
  7771 pipe_wait                                cron            S
  7772 wait                                     bash            Ss
  7773 drbd_al_begin_io                         run-crons       D
  7778 drbd_al_begin_io                         afpd            D
  8002 select                                   smbd            S
  8088 select                                   smbd            S
  8220 drbd_al_begin_io                         afpd            D
  8222 log_wait_for_space                       cnid_dbd        D
  8482 drbd_al_begin_io                         emerge          D
  9451 select                                   smbd            S
  9575 drbd_al_begin_io                         afpd            D
  9613 wait                                     mail.alert      S
  9614 unix_stream_recvmsg                      sendmail        S
  9616 drbd_al_begin_io                         postdrop        D
  9633 sk_wait_data                             afpd            S
  9697 select                                   pickup          S
  9918 drbd_al_begin_io                         emerge          D
  9924 drbd_al_begin_io                         sshd            D
  9936 unix_stream_recvmsg                      sshd            Ss
  9941 select                                   sshd            S
  9942 wait                                     bash            Ss
  9951 unix_stream_recvmsg                      sshd            Ss
  9956 select                                   sshd            S
  9957 wait                                     bash            Ss
  9962 read_chan                                bash            S+
10126 drbd_thread_setup                        drbd6_worker    S
10136 select                                   smbd            S
10142 sk_wait_data                             drbd6_asender   S
10143 sk_wait_data                             drbd0_asender   S
10144 sk_wait_data                             drbd2_asender   S
10145 sk_wait_data                             drbd1_asender   S
10146 sk_wait_data                             drbd3_asender   S
10147 sk_wait_data                             drbd7_asender   S
10163 -                                        ps              R+


>* get a backtrace of the stuck processess
>   e.g. echo t > /proc/sysrq-trigger
>   (again, everything that may be related)
>   note that these are not necessarily reliable,
>   but may be helpful to understand whats going on.
>
[951859.938308]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951859.939076]        <ffffffff8041bafd>{sk_wait_data+149} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951859.939852]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80287dc4>{default_wake_function+13}
[951859.940634]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff8021d97c>{tcp_recvmsg+938}
[951859.941417]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951859.942201]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff80276ee1>{__smp_call_function+104}
[951859.942973]        <ffffffff80276d8c>{do_flush_tlb_all+0} 
<ffffffff80267ae8>{_spin_unlock+9}
[951859.943739]        <ffffffff80276f47>{smp_call_function+62} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951859.944517]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff880d2fda>{:drbd:drbd_recv+184}
[951859.945318]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff880d33e6>{:drbd:drbd_recv_header+23}
[951859.946115]        <ffffffff880d741b>{:drbd:drbdd_init+248} 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207}
[951859.946915]        <ffffffff8026331a>{child_rip+8} 
<ffffffff880dc62b>{:drbd:drbd_thread_setup+0}
[951859.947693]        <ffffffff80263312>{child_rip+0}
[951859.948376] drbd2_receive S ffff81017dc77b18     0  6773      1 
6775  6771 (L-TLB)
[951859.949312] ffff81017dc77b18 ffff8100551cb830 0000000000000008 
ffff81017dc77a98
[951859.949799]        ffffffff802327ca 0000000000000014 
0000000000000000 0000000000047580
[951859.950616]        0000000000000144 000361afa69de48e
[951859.951085] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951859.951564]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951859.952336]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff8041bafd>{sk_wait_data+149}
[951859.953104]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951859.953883]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff8021d97c>{tcp_recvmsg+938}
[951859.954675]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951859.955458]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff80276efa>{__smp_call_function+129}
[951859.956232]        <ffffffff80276ee1>{__smp_call_function+104} 
<ffffffff80276d8c>{do_flush_tlb_all+0}
[951859.956999]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80276f47>{smp_call_function+62}
[951859.957774]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951859.958562]        <ffffffff880d2fda>{:drbd:drbd_recv+184} 
<ffffffff880d5bbf>{:drbd:receive_bitmap+0}
[951859.959361]        <ffffffff880d33e6>{:drbd:drbd_recv_header+23} 
<ffffffff880d741b>{:drbd:drbdd_init+248}
[951859.960156] 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207} 
<ffffffff8026331a>{child_rip+8}
[951859.960942]        <ffffffff880dc62b>{:drbd:drbd_thread_setup+0} 
<ffffffff80263312>{child_rip+0}
[951859.961990] drbd3_receive S ffff81017dc43b18     0  6775      1 
6777  6773 (L-TLB)
[951859.962921] ffff81017dc43b18 ffff8100551cb830 0000000000000008 
ffff81017dc43a98
[951859.963406]        ffffffff802327ca 0000000000000014 
0000000000000000 0000000000047580
[951859.964222]        000000000000012f 000361afa6e17d60
[951859.964691] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951859.965170]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951859.965943]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff8041bafd>{sk_wait_data+149}
[951859.966711]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951859.967491]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff8021d97c>{tcp_recvmsg+938}
[951859.968281]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951859.969063]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff80276ee1>{__smp_call_function+104}
[951859.969838]        <ffffffff80276d8c>{do_flush_tlb_all+0} 
<ffffffff80267ae8>{_spin_unlock+9}
[951859.970603]        <ffffffff80276f47>{smp_call_function+62} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951859.971390]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff880d2fda>{:drbd:drbd_recv+184}
[951859.972186]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff880d33e6>{:drbd:drbd_recv_header+23}
[951859.972982]        <ffffffff880d741b>{:drbd:drbdd_init+248} 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207}
[951859.973779]        <ffffffff8026331a>{child_rip+8} 
<ffffffff880dc62b>{:drbd:drbd_thread_setup+0}
[951859.974563]        <ffffffff80263312>{child_rip+0}
[951859.975254] drbd8_receive D ffff8101000ebd78     0  6777      1 
6779  6775 (L-TLB)
[951859.976184] ffff8101000ebd78 ffff8101000ebe38 ffffffff8023150f 
0000000000000292
[951859.976666]        0000000000000292 0000000000000000 
0000000000000001 0000000100000000
[951859.977479]        0000000000000856 0003612a263a2f47
[951859.984065] Call Trace: <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff880cca29>{:drbd:drbd_determin_dev_size+186}
[951859.984911]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951859.985691]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff880d542c>{:drbd:receive_param+915}
[951859.986488]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff880d5099>{:drbd:receive_param+0}
[951859.987279]        <ffffffff880d74c0>{:drbd:drbdd_init+413} 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207}
[951859.988075]        <ffffffff8026331a>{child_rip+8} 
<ffffffff880dc62b>{:drbd:drbd_thread_setup+0}
[951859.988857]        <ffffffff80263312>{child_rip+0}
[951859.989545] drbd4_receive D ffff81017d505d78     0  6779      1 
6781  6777 (L-TLB)
[951859.990477] ffff81017d505d78 ffff81017d505e38 ffffffff8023150f 
0000000000000292
[951859.990957]        0000000000000292 0000000000000000 
0000000000000001 0000000100000000
[951859.991768]        0000000000000c9f 00036129c7bf68b4
[951859.992237] Call Trace: <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff880cca29>{:drbd:drbd_determin_dev_size+186}
[951859.993082]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951859.993862]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff880d542c>{:drbd:receive_param+915}
[951859.994658]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff880d5099>{:drbd:receive_param+0}
[951859.995450]        <ffffffff880d74c0>{:drbd:drbdd_init+413} 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207}
[951859.996247]        <ffffffff8026331a>{child_rip+8} 
<ffffffff880dc62b>{:drbd:drbd_thread_setup+0}
[951859.997030]        <ffffffff80263312>{child_rip+0}
[951859.997722] drbd5_receive D ffff8100ee1d3d78     0  6781      1 
6783  6779 (L-TLB)
[951859.998661] ffff8100ee1d3d78 ffff8100ee1d3e38 ffffffff8023150f 
0000000000000292
[951859.999146]        0000000000000292 0000000000000000 
0000000000000001 0000000100000000
[951859.999965]        0000000000000e5d 00036129dc2bb8fa
[951860.000434] Call Trace: <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff880cca29>{:drbd:drbd_determin_dev_size+186}
[951860.001278]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.002059]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff880d542c>{:drbd:receive_param+915}
[951860.002847]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff880d5099>{:drbd:receive_param+0}
[951860.003643]        <ffffffff880d74c0>{:drbd:drbdd_init+413} 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207}
[951860.004436]        <ffffffff8026331a>{child_rip+8} 
<ffffffff880dc62b>{:drbd:drbd_thread_setup+0}
[951860.005211]        <ffffffff80263312>{child_rip+0}
[951860.005896] drbd6_receive S ffff8100ee1d5b18     0  6783      1 
7013  6781 (L-TLB)
[951860.006835] ffff8100ee1d5b18 0000000000000008 0000000000000008 
ffffffff80365dee
[951860.007319]        ffff810050306ba0 ffff8100ee1d5a78 
0000000000000000 0000000030333035
[951860.008138]        0000000000024cb2 0003617aa74955ca
[951860.008606] Call Trace: <ffffffff80365dee>{kobject_release+0} 
<ffffffff80249c05>{try_to_wake_up+982}
[951860.009440]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.010214]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff8041bafd>{sk_wait_data+149}
[951860.010981]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80287e09>{__wake_up_common+67}
[951860.011755]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff880d5bbf>{:drbd:receive_bitmap+0}
[951860.012542]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff880d5bbf>{:drbd:receive_bitmap+0}
[951860.013332]        <ffffffff8023335c>{sock_common_recvmsg+47} 
<ffffffff8023150f>{sock_recvmsg+244}
[951860.014107]        <ffffffff80276ee1>{__smp_call_function+104} 
<ffffffff80276d8c>{do_flush_tlb_all+0}
[951860.014878]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80276f47>{smp_call_function+62}
[951860.015661]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951860.016438]        <ffffffff880d2fda>{:drbd:drbd_recv+184} 
<ffffffff880d5bbf>{:drbd:receive_bitmap+0}
[951860.017245]        <ffffffff880d33e6>{:drbd:drbd_recv_header+23} 
<ffffffff880d741b>{:drbd:drbdd_init+248}
[951860.018041] 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207} 
<ffffffff8026331a>{child_rip+8}
[951860.018823]        <ffffffff880dc62b>{:drbd:drbd_thread_setup+0} 
<ffffffff80263312>{child_rip+0}
[951860.019867] heartbeat     S ffff8100edc07b28     0  7013      1 
7035    7184  6783 (NOTLB)
[951860.020805] ffff8100edc07b28 ffff810100086100 ffffffff80267b09 
000361b5f14b9677
[951860.021290]        ffff810100070000 ffff81010002d340 
0000000000000001 00000001edc07b38
[951860.022106]        0000000000002ffc 000361b5f14bc673
[951860.022573] Call Trace: <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff8021d023>{__mod_timer+179}
[951860.023406]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.024179]        <ffffffff80230770>{do_sys_poll+783} 
<ffffffff8024d71a>{unix_stream_sendmsg+587}
[951860.024962]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff8021ea22>{__pollwait+0}
[951860.025727]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.026506]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.027282]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80267a0f>{_spin_lock_irqsave+16}
[951860.028061]        <ffffffff8022c8e7>{sys_recvfrom+184} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951860.028835]        <ffffffff80235144>{do_setitimer+345} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951860.029616]        <ffffffff802966e9>{sys_times+234} 
<ffffffff8024f3f5>{sys_poll+73}
[951860.030392]        <ffffffff80262222>{system_call+126}
[951860.031095] heartbeat     S ffff8100edc75dc8     0  7035   7013 
7036       (NOTLB)
[951860.032031] ffff8100edc75dc8 ffff8100edc74000 ffff8100edc75d58 
ffffffff8024ae77
[951860.032516]        000000004be31a50 0000000000000000 
ffffffff8029dd1e 00000001edc74000
[951860.033328]        0000000000000511 00035d44463e52dc
[951860.033792] Call Trace: <ffffffff8024ae77>{pipe_wait+158} 
<ffffffff8029dd1e>{debug_mutex_add_waiter+147}
[951860.034619]        <ffffffff8024ae4f>{pipe_wait+118} 
<ffffffff80267ae8>{_spin_unlock+9}
[951860.035390]        <ffffffff8024ae54>{pipe_wait+123} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.036162]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80266cb3>{mutex_lock+38}
[951860.036933]        <ffffffff8022fb74>{pipe_readv+779} 
<ffffffff8022c8e7>{sys_recvfrom+184}
[951860.037705]        <ffffffff802c513f>{pipe_read+28} 
<ffffffff8020ae40>{vfs_read+175}
[951860.038472]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951860.039523] heartbeat     S ffff8100edd13b28     0  7036   7013 
7037  7035 (NOTLB)
[951860.040467] ffff8100edd13b28 ffff8100f6c02000 0000000000000202 
0000000000000000
[951860.040952]        0000000000000202 0000000000000000 
ffff810100070000 00000001edd13b38
[951860.041768]        0000000000011dae 000361b5edbd599b
[951860.042236] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.043071]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80230770>{do_sys_poll+783}
[951860.043850]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff8021ea22>{__pollwait+0}
[951860.044619]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80267ae8>{_spin_unlock+9}
[951860.045395]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.046170]        <ffffffff804193cd>{move_addr_to_kernel+64} 
<ffffffff8022c8e7>{sys_recvfrom+184}
[951860.046951]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff8024f3f5>{sys_poll+73}
[951860.047714]        <ffffffff80262222>{system_call+126}
[951860.048405] heartbeat     S ffff8100edc71b28     0  7037   7013 
7036 (NOTLB)
[951860.049341] ffff8100edc71b28 ffff8101678267e0 ffff81008c46cd20 
ffff8100f7f7b500
[951860.049835]        00000000ffffff00 0000000000000000 
0000000000000010 0000000000000202
[951860.050652]        000000000000c82c 00035d438d1e535d
[951860.051121] Call Trace: <ffffffff802665a4>{schedule_timeout+34}
[951860.051603] 
<ffffffff8024add1>{prepare_to_wait_exclusive+95} 
<ffffffff802593cc>{skb_recv_datagram+439}
[951860.052383]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.053164]        <ffffffff80446e70>{udp_recvmsg+102} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951860.053935]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff8021ea22>{__pollwait+0}
[951860.054707]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.055483]        <ffffffff80419435>{move_addr_to_user+95} 
<ffffffff8022c8e7>{sys_recvfrom+184}
[951860.056258]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80262222>{system_call+126}
[951860.063425] mon           S ffff81017a895e98     0  7184      1 
5444    7327  7013 (NOTLB)
[951860.064363] ffff81017a895e98 ffff81017a895df8 ffffffff8029dd1e 
ffff81017a894000
[951860.064848]        000000008023ba87 0000000000000000 
ffff81017a895e08 0000000100000001
[951860.065665]        00000000000051a7 00035eaafab7f7be
[951860.066131] Call Trace: <ffffffff8029dd1e>{debug_mutex_add_waiter+147}
[951860.066612]        <ffffffff80246e4f>{pipe_release+165} 
<ffffffff80228826>{do_wait+2714}
[951860.067383]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80245f39>{sys_rt_sigaction+140}
[951860.068153]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8025845f>{sys_wait4+40}
[951860.068926]        <ffffffff80262222>{system_call+126}
[951860.069621] portsentry    S ffff8100eca59b98     0  7327      1 
7329  7184 (NOTLB)
[951860.070558] ffff8100eca59b98 ffffffff8055e140 ffff81000c003800 
ffff8100eddda080
[951860.071042]        000000000c003800 0000000000000000 
0000000000000000 00000000eca59cb4
[951860.071856]        00000000000000d9 000361b6181d22be
[951860.072326] Call Trace: <ffffffff802665a4>{schedule_timeout+34}
[951860.072806] 
<ffffffff8024add1>{prepare_to_wait_exclusive+95} 
<ffffffff802593cc>{skb_recv_datagram+439}
[951860.073584]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.074360]        <ffffffff80229144>{__kfree_skb+188} 
<ffffffff804460ae>{raw_recvmsg+123}
[951860.075129]        <ffffffff8023335c>{sock_common_recvmsg+47} 
<ffffffff8024891a>{do_sock_read+159}
[951860.075898]        <ffffffff804199d7>{sock_aio_read+87} 
<ffffffff8020c99c>{do_sync_read+237}
[951860.076664]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8020ae53>{vfs_read+194}
[951860.077433]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951860.078485] portsentry    S ffff8100ec5b3b98     0  7329      1 
7444  7327 (NOTLB)
[951860.079418] ffff8100ec5b3b98 ffffffff8055e140 ffff81000c003800 
ffff8100f7ea47b8
[951860.079903]        0000000000802100 0000000000000000 
0000000000000000 00000000ec5b3cb4
[951860.080720]        0000000000000118 0003619ee7a337d9
[951860.081189] Call Trace: <ffffffff802665a4>{schedule_timeout+34}
[951860.081671] 
<ffffffff8024add1>{prepare_to_wait_exclusive+95} 
<ffffffff802593cc>{skb_recv_datagram+439}
[951860.082450]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.083242]        <ffffffff80229144>{__kfree_skb+188} 
<ffffffff804460ae>{raw_recvmsg+123}
[951860.084012]        <ffffffff8023335c>{sock_common_recvmsg+47} 
<ffffffff8024891a>{do_sock_read+159}
[951860.084781]        <ffffffff804199d7>{sock_aio_read+87} 
<ffffffff8020c99c>{do_sync_read+237}
[951860.085553]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951860.086326]        <ffffffff80265b94>{thread_return+101} 
<ffffffff8020ae53>{vfs_read+194}
[951860.087095]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951860.088143] master        S ffff8100ec0afa48     0  7444      1 
7459    7589  7329 (NOTLB)
[951860.089077] ffff8100ec0afa48 ffff81000000fd00 000200d000000000 
0000000000000286
[951860.089562]        000000000000fd00 0000000000000000 
ffffffff806825c0 00000000ec0afa58
[951860.090373]        0000000000001388 000361a930cf20f7
[951860.090839] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.091669]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.092440]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.093211]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.093990]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.094768]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.095542]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.096318]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8026fa86>{do_gettimeofday+84}
[951860.097092]        <ffffffff80216c08>{sys_select+710} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951860.097867]        <ffffffff80235144>{do_setitimer+345} 
<ffffffff80262222>{system_call+126}
[951860.098921] qmgr          S ffff81017a93fa48     0  7459   7444 
9697       (NOTLB)
[951860.099858] ffff81017a93fa48 ffff810100086100 ffffffff802fbd0d 
000361831116ae7e
[951860.100343]        ffff810100070000 ffff81010002d340 
0000000000000001 000000017a93fa58
[951860.101160]        0000000000002fca 0003618311185c9e
[951860.101628] Call Trace: <ffffffff802fbd0d>{do_get_write_access+1383}
[951860.102107]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.102877]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.103648]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.104416]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80219dfb>{__getblk+52}
[951860.105181]        <ffffffff802070e4>{check_poison_obj+52} 
<ffffffff802121ff>{poison_obj+58}
[951860.105948]        <ffffffff802e8ea2>{ext3_htree_store_dirent+58} 
<ffffffff8022226a>{dbg_redzone1+32}
[951860.106716]        <ffffffff802e8ea2>{ext3_htree_store_dirent+58} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951860.107493]        <ffffffff802e8ea2>{ext3_htree_store_dirent+58} 
<ffffffff802bc87f>{__kmalloc+256}
[951860.108267] 
<ffffffff802e8f80>{ext3_htree_store_dirent+280} 
<ffffffff802ef282>{htree_dirblock_to_tree+199}
[951860.109048]        <ffffffff802ef319>{ext3_htree_fill_tree+133} 
<ffffffff80225ecf>{filldir+111}
[951860.109819]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951860.110598]        <ffffffff8025a7ef>{pipe_ioctl+97} 
<ffffffff80267ae8>{_spin_unlock+9}
[951860.111364] 
<ffffffff80266e89>{__mutex_unlock_slowpath+466} 
<ffffffff80266eb1>{mutex_unlock+13}
[951860.112135]        <ffffffff8025a7ef>{pipe_ioctl+97} 
<ffffffff80267ae8>{_spin_unlock+9}
[951860.112898]        <ffffffff80267c71>{unlock_kernel+62} 
<ffffffff80243fc0>{do_ioctl+108}
[951860.113667]        <ffffffff8023114f>{vfs_ioctl+623} 
<ffffffff80262222>{system_call+126}
[951860.114720] cron          S ffff8100ec5b1e98     0  7589      1 
27942    7717  7444 (NOTLB)
[951860.115658] ffff8100ec5b1e98 000000004488ad95 0000000000094fa4 
0000000000000001
[951860.116143]        000000001c6876d8 ffff8100ec5b1e18 
0000000000000000 00000000ec5b1e28
[951860.116961]        00000000000017c3 000361a9dd1fdeb4
[951860.117428] Call Trace: <ffffffff8023e208>{hrtimer_start+192} 
<ffffffff8026736d>{do_nanosleep+67}
[951860.118256]        <ffffffff8025eb54>{hrtimer_nanosleep+78} 
<ffffffff8029d3a6>{hrtimer_wakeup+0}
[951860.119025]        <ffffffff80258762>{sys_nanosleep+93} 
<ffffffff80262222>{system_call+126}
[951860.120069] agetty        S ffff8100ec001d88     0  7717      1 
7718  7589 (NOTLB)
[951860.121007] ffff8100ec001d88 0000000000000246 0000000000000246 
ffff8100ec001ce8
[951860.121493]        0000000000000246 000000000000000d 
0000000000000000 00000000ec001d18
[951860.122310]        000000000002649d 0001378d9187c75c
[951860.122779] Call Trace: <ffffffff80229c96>{read_chan+607} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951860.123614]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8024cb90>{add_wait_queue+63}
[951860.124384]        <ffffffff80229e72>{read_chan+1083} 
<ffffffff80287db7>{default_wake_function+0}
[951860.125158]        <ffffffff8022f052>{__wake_up+65} 
<ffffffff80287db7>{default_wake_function+0}
[951860.125929]        <ffffffff80233d87>{tty_read+143} 
<ffffffff8020ae40>{vfs_read+175}
[951860.126697]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951860.127751] agetty        S ffff8100ec59fd88     0  7718      1 
7719  7717 (NOTLB)
[951860.128687] ffff8100ec59fd88 0000000000000246 0000000000000246 
ffff8100ec59fce8
[951860.129170]        0000000000000246 0000000000000000 
0000000000049a8b 00000000ec59fd18
[951860.129983]        000000000000d628 0000002da0a4e2ee
[951860.130451] Call Trace: <ffffffff80229c96>{read_chan+607} 
<ffffffff8029dd1e>{debug_mutex_add_waiter+147}
[951860.131282] 
<ffffffff8023ba87>{debug_mutex_free_waiter+133} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.132058]        <ffffffff8024cb90>{add_wait_queue+63} 
<ffffffff80229e72>{read_chan+1083}
[951860.132827]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022f052>{__wake_up+65}
[951860.133589]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80233d87>{tty_read+143}
[951860.134368]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.141248]        <ffffffff80262222>{system_call+126}
[951860.141948] agetty        S ffff8100ec77bd88     0  7719      1 
7720  7718 (NOTLB)
[951860.142886] ffff8100ec77bd88 0000000000000246 0000000000000246 
ffff8100ec77bce8
[951860.143373]        0000000000000246 0000000000000000 
0000000000049a8b 00000000ec77bd18
[951860.144191]        000000000000af6d 0000002da0ab0dc5
[951860.144657] Call Trace: <ffffffff80229c96>{read_chan+607} 
<ffffffff8029dd1e>{debug_mutex_add_waiter+147}
[951860.145491] 
<ffffffff8023ba87>{debug_mutex_free_waiter+133} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.146268]        <ffffffff8024cb90>{add_wait_queue+63} 
<ffffffff80229e72>{read_chan+1083}
[951860.147036]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022f052>{__wake_up+65}
[951860.147799]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80233d87>{tty_read+143}
[951860.148570]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.149334]        <ffffffff80262222>{system_call+126}
[951860.150034] agetty        S ffff8100ec0b7d88     0  7720      1 
7721  7719 (NOTLB)
[951860.150972] ffff8100ec0b7d88 0000000000000246 0000000000000246 
ffff8100ec0b7ce8
[951860.151456]        0000000000000246 0000000000000000 
0000000000049a8b 00000000ec0b7d18
[951860.152270]        000000000000a602 0000002da0b0e3df
[951860.152738] Call Trace: <ffffffff80229c96>{read_chan+607} 
<ffffffff8029dd1e>{debug_mutex_add_waiter+147}
[951860.153572] 
<ffffffff8023ba87>{debug_mutex_free_waiter+133} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.154349]        <ffffffff8024cb90>{add_wait_queue+63} 
<ffffffff80229e72>{read_chan+1083}
[951860.155121]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022f052>{__wake_up+65}
[951860.155890]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80233d87>{tty_read+143}
[951860.156663]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.157428]        <ffffffff80262222>{system_call+126}
[951860.158126] agetty        S ffff8100ec71dd88     0  7721      1 
7722  7720 (NOTLB)
[951860.159063] ffff8100ec71dd88 0000000000000246 0000000000000246 
ffff8100ec71dce8
[951860.159547]        0000000000000246 0000000000000000 
0000000000049a8b 00000000ec71dd18
[951860.160365]        000000000000a6b1 0000002da0b6c018
[951860.160832] Call Trace: <ffffffff80229c96>{read_chan+607} 
<ffffffff8029dd1e>{debug_mutex_add_waiter+147}
[951860.161662] 
<ffffffff8023ba87>{debug_mutex_free_waiter+133} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.162432]        <ffffffff8024cb90>{add_wait_queue+63} 
<ffffffff80229e72>{read_chan+1083}
[951860.163204]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022f052>{__wake_up+65}
[951860.163974]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80233d87>{tty_read+143}
[951860.164746]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.165511]        <ffffffff80262222>{system_call+126}
[951860.166208] agetty        S ffff8100ec1a1d88     0  7722      1 
9544  7721 (NOTLB)
[951860.167144] ffff8100ec1a1d88 0000000000000246 0000000000000246 
ffff8100ec1a1ce8
[951860.167630]        0000000000000246 0000000000000000 
0000000000000000 00000000ec1a1d18
[951860.168446]        000000000000bb13 0000002da0d3fd8d
[951860.168913] Call Trace: <ffffffff80229c96>{read_chan+607} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951860.169749]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8024cb90>{add_wait_queue+63}
[951860.170520]        <ffffffff80229e72>{read_chan+1083} 
<ffffffff80287db7>{default_wake_function+0}
[951860.171295]        <ffffffff8022f052>{__wake_up+65} 
<ffffffff80287db7>{default_wake_function+0}
[951860.172064]        <ffffffff80233d87>{tty_read+143} 
<ffffffff8020ae40>{vfs_read+175}
[951860.172828]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951860.173882] kjournald     S ffff8100eb9abe68     0  8923     11 
8971  3844 (L-TLB)
[951860.174819] ffff8100eb9abe68 000000008055e140 ffff8100f763e4a0 
00000fd400000000
[951860.175304]        ffff8100567e602c 0000000000000000 
0000000000000000 000000007f13c220
[951860.176114]        00000000000002db 000361678636ac0b
[951860.176579] Call Trace: <ffffffff802ffdee>{kjournald+455} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.177412]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802ffc27>{kjournald+0}
[951860.178181]        <ffffffff8023420c>{kthread+208} 
<ffffffff8026331a>{child_rip+8}
[951860.178943]        <ffffffff8023413c>{kthread+0} 
<ffffffff80263312>{child_rip+0}
[951860.179982] kjournald     S ffff8100ebd17e68     0  8971     11 
9019  8923 (L-TLB)
[951860.180917] ffff8100ebd17e68 000000008055e140 ffff8100f761aa88 
00000fcc00000000
[951860.181402]        ffff810114b7f034 0000000000000000 
0000000000000000 000000000497af40
[951860.182218]        00000000000002cd 00036003dd1b135c
[951860.182687] Call Trace: <ffffffff802ffdee>{kjournald+455} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.183523]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802ffc27>{kjournald+0}
[951860.184296]        <ffffffff8023420c>{kthread+208} 
<ffffffff8026331a>{child_rip+8}
[951860.185062]        <ffffffff8023413c>{kthread+0} 
<ffffffff80263312>{child_rip+0}
[951860.186102] kjournald     S ffff8100ebeede68     0  9019     11 
9067  8971 (L-TLB)
[951860.187038] ffff8100ebeede68 000000008055e140 ffffffff8020785f 
0000000000000000
[951860.187522]        0000000000000000 0000000000000000 
0000000000000000 00000000ebeedde8
[951860.188337]        0000000000000247 000361afa70e0f09
[951860.188806] Call Trace: <ffffffff8020785f>{_raw_spin_lock+146} 
<ffffffff802ffdee>{kjournald+455}
[951860.189637]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.190413]        <ffffffff802ffc27>{kjournald+0} 
<ffffffff8023420c>{kthread+208}
[951860.191171]        <ffffffff8026331a>{child_rip+8} 
<ffffffff8023413c>{kthread+0}
[951860.191937]        <ffffffff80263312>{child_rip+0}
[951860.192628] kjournald     S ffff8100eba4de68     0  9067     11 
9115  9019 (L-TLB)
[951860.193563] ffff8100eba4de68 000000008055e140 0000000300000000 
0000000000000000
[951860.194047]        0000000000000000 0000000000000000 
0000000000000000 00000000eba4dde8
[951860.194864]        0000000000000357 000361afa70b3ab5
[951860.195333] Call Trace: <ffffffff802ffdee>{kjournald+455} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.196170]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802ffc27>{kjournald+0}
[951860.196941]        <ffffffff8023420c>{kthread+208} 
<ffffffff8026331a>{child_rip+8}
[951860.197708]        <ffffffff8023413c>{kthread+0} 
<ffffffff80263312>{child_rip+0}
[951860.198750] kjournald     D ffff8100eba51a38     0  9115     11 
9163  9067 (L-TLB)
[951860.199686] ffff8100eba51a38 ffffffff8055e140 ffff81013d1fb740 
ffff8101591e9db0
[951860.200172]        000000003ba06178 0000000000000000 
0000000000000000 000000000cd38800
[951860.200988]        000000000000006b 00031e4fe8684894
[951860.201456] Call Trace: <ffffffff80265ccd>{wait_for_completion+165}
[951860.201940]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff802aabdd>{mempool_alloc_slab+17}
[951860.202709]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff880d9b1c>{:drbd:drbd_al_begin_io+706}
[951860.203498]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff802237b5>{mempool_alloc+73}
[951860.204265]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022ed34>{blk_recount_segments+122}
[951860.205034] 
<ffffffff880d9c26>{:drbd:w_al_write_transaction+0} 
<ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951860.205836]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951860.206605]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951860.207384]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951860.208160]        <ffffffff802fb494>{__journal_file_buffer+347} 
<ffffffff80234d09>{submit_bio+203}
[951860.208937]        <ffffffff8021abd8>{submit_bh+267} 
<ffffffff802fd5d3>{journal_commit_transaction+2359}
[951860.209722]        <ffffffff8024e0cc>{try_to_del_timer_sync+83} 
<ffffffff802ffcf1>{kjournald+202}
[951860.210498]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.211290]        <ffffffff802ffc27>{kjournald+0} 
<ffffffff8023420c>{kthread+208}
[951860.212055]        <ffffffff8026331a>{child_rip+8} 
<ffffffff8023413c>{kthread+0}
[951860.212821]        <ffffffff80263312>{child_rip+0}
[951860.213511] kjournald     S ffff8100eb9c1e68     0  9163     11 
9211  9115 (L-TLB)
[951860.220562] ffff8100eb9c1e68 000000008055e140 0000000000000246 
00000f9c00000000
[951860.221047]        000000000b03a064 0000000000000000 
ffff8100ebac6000 00000000d05e5400
[951860.221863]        00000000000007aa 000359b372a82748
[951860.222332] Call Trace: <ffffffff802ffdee>{kjournald+455} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.223166]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802ffc27>{kjournald+0}
[951860.223939]        <ffffffff8023420c>{kthread+208} 
<ffffffff8026331a>{child_rip+8}
[951860.224700]        <ffffffff8023413c>{kthread+0} 
<ffffffff80263312>{child_rip+0}
[951860.225740] kjournald     S ffff8100ebdd5e68     0  9211     11 
9259  9163 (L-TLB)
[951860.226673] ffff8100ebdd5e68 000000008055e140 ffff8100ebdd4000 
00000fc400000000
[951860.227157]        000000005ed7803c 0000000000000000 
ffff8100eba97000 0000000063efc130
[951860.227974]        0000000000000345 00035b0b26cb122c
[951860.228443] Call Trace: <ffffffff802ffdee>{kjournald+455} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.229276]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802ffc27>{kjournald+0}
[951860.230048]        <ffffffff8023420c>{kthread+208} 
<ffffffff8026331a>{child_rip+8}
[951860.230810]        <ffffffff8023413c>{kthread+0} 
<ffffffff80263312>{child_rip+0}
[951860.231851] kjournald     S ffff8100ebae5e68     0  9259     11 
9307  9211 (L-TLB)
[951860.232780] ffff8100ebae5e68 000000008055e140 0000000300000000 
00000fd400000000
[951860.233262]        ffff8100aca3602c 0000000000000000 
0000000000000000 0000000067fc74f0
[951860.234074]        0000000000000270 00035df01d24102e
[951860.234544] Call Trace: <ffffffff802ffdee>{kjournald+455} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.235382]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802ffc27>{kjournald+0}
[951860.236154]        <ffffffff8023420c>{kthread+208} 
<ffffffff8026331a>{child_rip+8}
[951860.236915]        <ffffffff8023413c>{kthread+0} 
<ffffffff80263312>{child_rip+0}
[951860.237957] kjournald     D ffff8100eba9fab8     0  9307     11 
32250  9259 (L-TLB)
[951860.238894] ffff8100eba9fab8 ffffffff8055e140 ffff8100a4f8e8b0 
ffff8100a4f8e8b0
[951860.239379]        000000000000bff8 0000000000000000 
0000000000000000 0000000000000093
[951860.240194]        00000000000000b5 00035e34bb7c83c1
[951860.240663] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951860.241520]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951860.242296]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951860.243072]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951860.243502]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951860.244270]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951860.245050]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951860.245825]        <ffffffff802fb494>{__journal_file_buffer+347} 
<ffffffff80234d09>{submit_bio+203}
[951860.246603]        <ffffffff8021abd8>{submit_bh+267} 
<ffffffff802fd5d3>{journal_commit_transaction+2359}
[951860.247377]        <ffffffff8024e0cc>{try_to_del_timer_sync+83} 
<ffffffff802ffcf1>{kjournald+202}
[951860.248140]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.248919]        <ffffffff802ffc27>{kjournald+0} 
<ffffffff8023420c>{kthread+208}
[951860.249684]        <ffffffff8026331a>{child_rip+8} 
<ffffffff8023413c>{kthread+0}
[951860.250451]        <ffffffff80263312>{child_rip+0}
[951860.251141] atalkd        S ffff8100ebb2ba48     0  9438      1 
9901  9822 (NOTLB)
[951860.252076] ffff8100ebb2ba48 ffff810100086100 ffffffff80267ae8 
ffff8100ebb2ba18
[951860.252561]        ffffffff88040ed1 0000000000000000 
0000000000000001 00000001ebb2bcd8
[951860.253379]        00000000000009d6 000361b5232b0f1a
[951860.253848] Call Trace: <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff88040ed1>{:tg3:tg3_start_xmit_dma_bug+1667}
[951860.254701]        <ffffffff8021eaf8>{__pollwait+214} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.255469] 
<ffffffff880a8a66>{:appletalk:__lock_atalk_dgram_poll+47}
[951860.255901]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.256677]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.257457]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.258234]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.259011]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.259789]        <ffffffff80292ef7>{__sigqueue_free+54} 
<ffffffff80292e42>{recalc_sigpending+18}
[951860.260571]        <ffffffff80293235>{__dequeue_signal+414} 
<ffffffff80216c08>{sys_select+710}
[951860.261342]        <ffffffff8022affa>{do_signal+1538} 
<ffffffff80245e7f>{sys_rt_sigreturn+712}
[951860.262111]        <ffffffff80262222>{system_call+126}
[951860.262804] smbd          S ffff8100eb02fa48     0  9544      1 
9548    9554  7722 (NOTLB)
[951860.263742] ffff8100eb02fa48 ffff810100086100 ffffffff802eba75 
0000000000000e4d
[951860.264228]        ffff8100a43bfc80 0000000000000000 
0000000000000001 00000001f761cee0
[951860.265044]        00000000000011e7 000361b5063295cf
[951860.265510] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951860.265990]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8022e8d1>{pipe_poll+54}
[951860.266761]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.267534]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.268310]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022258c>{__up_read+147}
[951860.269085]        <ffffffff80269a07>{do_page_fault+1189} 
<ffffffff80267ae8>{_spin_unlock+9}
[951860.269866]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8023d889>{remove_wait_queue+64}
[951860.270639]        <ffffffff8022885d>{do_wait+2769} 
<ffffffff80245e7f>{sys_rt_sigreturn+712}
[951860.271413]        <ffffffff80262222>{system_call+126}
[951860.272110] smbd          S ffff8100eb04ff68     0  9548   9544 
8270       (NOTLB)
[951860.273048] ffff8100eb04ff68 ffff8100eb04ff48 ffff810000030002 
0000000000000246
[951860.273532]        0000000000000000 0000000000000000 
0000000000000001 00000001ebdc5180
[951860.274350]        000000000000c0b3 000000578e2fb9fe
[951860.274819] Call Trace: <ffffffff8023c3bd>{sys_pause+25} 
<ffffffff80262222>{system_call+126}
[951860.275923] nmbd          S ffff8100eb24da48     0  9554      1 
9688  9544 (NOTLB)
[951860.276853] ffff8100eb24da48 ffffffff8055e140 ffffffff80232c3c 
000361b3d38d19f6
[951860.277340]        ffffffff806825c0 ffff81000c005340 
0000000000000000 00000000eb24da58
[951860.278157]        0000000000000a64 000361b3d38d777e
[951860.278625] Call Trace: <ffffffff80232c3c>{qdisc_restart+32} 
<ffffffff8021d023>{__mod_timer+179}
[951860.279453]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.280225]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.280997]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.281776]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.282556]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80421da2>{netdev_run_todo+39}
[951860.283346]        <ffffffff8029dd1e>{debug_mutex_add_waiter+147} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951860.284124]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff80421fef>{netdev_run_todo+628}
[951860.284897]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80266e89>{__mutex_unlock_slowpath+466}
[951860.285673]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.286447]        <ffffffff8023b5ff>{generic_drop_inode+367} 
<ffffffff802c854b>{d_free+49}
[951860.287214]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff80212114>{__fput+365}
[951860.287984]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80262222>{system_call+126}
[951860.289039] mysqld        S ffff81017ddbda48     0  9688      1 
9734  9554 (NOTLB)
[951860.289968] ffff81017ddbda48 ffffffff8055e140 0000000000000000 
ffff8101002c70c0
[951860.290450]        0000000000000000 0000000000000000 
0000000000000300 0000000000000001
[951860.291262]        00000000000001de 0003615d189dfa69
[951860.291731] Call Trace: <ffffffff802665a4>{schedule_timeout+34}
[951860.292213]        <ffffffff802312a4>{unix_poll+44} 
<ffffffff80211080>{do_select+1099}
[951860.299102]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.299873]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80365dee>{kobject_release+0}
[951860.300646]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff8021b07c>{bad_range+26}
[951860.301414]        <ffffffff8020a121>{get_page_from_freelist+627} 
<ffffffff8021b07c>{bad_range+26}
[951860.302189]        <ffffffff80216098>{__bitmap_weight+122} 
<ffffffff8022e7cd>{sched_balance_self+626}
[951860.302969]        <ffffffff80287c37>{scheduler_tick+815} 
<ffffffff80216c08>{sys_select+710}
[951860.303740]        <ffffffff80298839>{alloc_pid+34} 
<ffffffff8023592f>{wake_up_new_task+689}
[951860.304503]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80265be2>{thread_return+179}
[951860.305271]        <ffffffff8026dcea>{sys_clone+35} 
<ffffffff80262222>{system_call+126}
[951860.306322] mysqld        S ffff8100e9941d58     0  9734      1 
9735  9688 (NOTLB)
[951860.307259] ffff8100e9941d58 ffff81000000fd00 ffff8100e9941cb8 
ffffffff8021b07c
[951860.307745]        0000000000010d10 0000000000000000 
ffff81000000f340 00000000e9941d28
[951860.308563]        00000000000058c5 00000057d2a979c7
[951860.309030] Call Trace: <ffffffff8021b07c>{bad_range+26} 
<ffffffff80267b3b>{_read_unlock_irq+9}
[951860.309860]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8024cb90>{add_wait_queue+63}
[951860.310634]        <ffffffff802405f0>{do_futex+671} 
<ffffffff80287db7>{default_wake_function+0}
[951860.311412]        <ffffffff8029e823>{sys_futex+239} 
<ffffffff80262222>{system_call+126}
[951860.312461] mysqld        S ffff8100e9943d58     0  9735      1 
9736  9734 (NOTLB)
[951860.313398] ffff8100e9943d58 ffff8100e919fe30 0000000000000000 
ffff8100e9943ca8
[951860.313884]        0000000080287dc4 0000000000000000 
ffffffff80287e09 0000000000000246
[951860.314701]        0000000000000a3c 00001d053ec780c5
[951860.315170] Call Trace: <ffffffff80287e09>{__wake_up_common+67}
[951860.315647]        <ffffffff8022258c>{__up_read+147} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.316417]        <ffffffff8024cb90>{add_wait_queue+63} 
<ffffffff802405f0>{do_futex+671}
[951860.317186]        <ffffffff80267b3b>{_read_unlock_irq+9} 
<ffffffff80287db7>{default_wake_function+0}
[951860.317966]        <ffffffff8029e823>{sys_futex+239} 
<ffffffff802bf729>{__do_fsync+55}
[951860.318736]        <ffffffff80262222>{system_call+126}
[951860.319425] mysqld        S ffff8100e9945d58     0  9736      1 
9737  9735 (NOTLB)
[951860.320361] ffff8100e9945d58 00000000000011ff ffff8100e9945cb8 
ffffffff8021b07c
[951860.320845]        0000000000010d10 0000000000000000 
ffff81000000f340 00000000e9945d28
[951860.321662]        000000000000934d 000275fb00aac0b9
[951860.322131] Call Trace: <ffffffff8021b07c>{bad_range+26} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.322965]        <ffffffff8024cb90>{add_wait_queue+63} 
<ffffffff802405f0>{do_futex+671}
[951860.323738]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8029e823>{sys_futex+239}
[951860.324531]        <ffffffff80262222>{system_call+126}
[951860.325228] mysqld        S ffff8100e9947d58     0  9737      1 
9819  9736 (NOTLB)
[951860.326165] ffff8100e9947d58 ffff8100e9947ca8 0000000000000246 
ffff8100ee1f0001
[951860.326650]        0000000000000001 0000000000000000 
0000000000000282 00000000e9947cd8
[951860.327467]        0000000000000811 00001d053c574904
[951860.327935] Call Trace: <ffffffff8029e3e0>{futex_requeue+646} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.328766]        <ffffffff8024cb90>{add_wait_queue+63} 
<ffffffff802405f0>{do_futex+671}
[951860.329538]        <ffffffff802e964c>{ext3_file_write+28} 
<ffffffff80218600>{do_sync_write+237}
[951860.330312]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8029e823>{sys_futex+239}
[951860.331086]        <ffffffff80246203>{sys_pwrite64+105} 
<ffffffff80262222>{system_call+126}
[951860.332140] mysqld        S ffff8100e90aba48     0  9819      1 
9820  9737 (NOTLB)
[951860.333068] ffff8100e90aba48 ffff810100086100 0000000000000000 
000361b61630677d
[951860.333548]        0000000000070000 0000000000000000 
ffff810100070000 00000001e90aba58
[951860.334363]        0000000000004250 000361b61632bc50
[951860.334833] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.335668]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.336435]        <ffffffff80267b3b>{_read_unlock_irq+9} 
<ffffffff8021252d>{__do_page_cache_readahead+274}
[951860.337214]        <ffffffff8020ca3d>{do_lookup+99} 
<ffffffff8021ea22>{__pollwait+0}
[951860.337975]        <ffffffff8020ceec>{dput+57} 
<ffffffff80209d9c>{__link_path_walk+3519}
[951860.338744]        <ffffffff80233c98>{blockable_page_cache_readahead+93}
[951860.339168]        <ffffffff8020cc76>{file_read_actor+129} 
<ffffffff8021b07c>{bad_range+26}
[951860.339940]        <ffffffff8020a121>{get_page_from_freelist+627} 
<ffffffff8021b07c>{bad_range+26}
[951860.340715]        <ffffffff8020a24a>{get_page_from_freelist+924} 
<ffffffff80216c08>{sys_select+710}
[951860.341498]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80265b94>{thread_return+101}
[951860.342275]        <ffffffff80262222>{system_call+126}
[951860.342969] mysqld        S ffff8100e90c1a48     0  9820      1 
9821  9819 (NOTLB)
[951860.343905] ffff8100e90c1a48 ffff810100086100 ffffffff8020785f 
000361b5c7a4bdbd
[951860.344389]        0000000000070000 0000000000000000 
ffff810100070000 00000001e90c1a58
[951860.345209]        000000000000d634 000361b5c7ac4597
[951860.345676] Call Trace: <ffffffff8020785f>{_raw_spin_lock+146} 
<ffffffff8021d023>{__mod_timer+179}
[951860.346507]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.347270]        <ffffffff80211080>{do_select+1099} 
<ffffffff80267b3b>{_read_unlock_irq+9}
[951860.348036]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff8020eea6>{__alloc_pages+105}
[951860.348805]        <ffffffff80287357>{find_busiest_group+304} 
<ffffffff80208eb1>{__handle_mm_fault+2332}
[951860.349581]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80265b94>{thread_return+101}
[951860.350350]        <ffffffff8021b07c>{bad_range+26} 
<ffffffff80216c08>{sys_select+710}
[951860.351126]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80265b94>{thread_return+101}
[951860.351899]        <ffffffff80262222>{system_call+126}
[951860.352594] mysqld        S ffff8100e919fd58     0  9821      1 
9822  9820 (NOTLB)
[951860.353530] ffff8100e919fd58 ffff8100be9eb820 0000000000000246 
ffff8100ee1c5801
[951860.354016]        0000000000000001 0000000000000000 
0000000000000001 00000001e919fcd8
[951860.354833]        0000000000002114 00032d89c03f2b93
[951860.355302] Call Trace: <ffffffff8022258c>{__up_read+147} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.356134]        <ffffffff8024cb90>{add_wait_queue+63} 
<ffffffff802405f0>{do_futex+671}
[951860.356905]        <ffffffff80216d62>{sys_select+1056} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951860.357680]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8029e823>{sys_futex+239}
[951860.358454]        <ffffffff8026f056>{math_state_restore+0} 
<ffffffff80262222>{system_call+126}
[951860.359514] mysqld        S ffff8100e8c43e48     0  9822      1 
9438  9821 (NOTLB)
[951860.360447] ffff8100e8c43e48 ffff8100e8c43db8 0000000000000065 
0000000000a78180
[951860.360928]        0000000000000000 0000000000000000 
0000000000a78180 00000000e8c43f08
[951860.361737]        0000000000000125 0003615d18a8c747
[951860.362202] Call Trace: <ffffffff8029d221>{ktime_get_ts+94} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.363037]        <ffffffff80293280>{dequeue_signal+60} 
<ffffffff8026664e>{schedule_timeout_interruptible+25}
[951860.363814]        <ffffffff80294c00>{sys_rt_sigtimedwait+468} 
<ffffffff80287db7>{default_wake_function+0}
[951860.364589]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff8021de74>{sigprocmask+227}
[951860.365359]        <ffffffff80231392>{sys_rt_sigprocmask+91} 
<ffffffff80262222>{system_call+126}
[951860.366412] cnid_metad    S ffff8100ebe61a48     0  9901      1 
11908    9910  9438 (NOTLB)
[951860.367350] ffff8100ebe61a48 ffffffff8055e140 0000000000000000 
000361b3e8f92fbb
[951860.367833]        ffffffff806825c0 ffff81000c005340 
0000000000000000 00000000ebe61a58
[951860.368652]        0000000000000225 000361b3e8f9430a
[951860.369121] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.369955]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.370730]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.371503]        <ffffffff8024d71a>{unix_stream_sendmsg+587} 
<ffffffff80258cea>{sock_sendmsg+235}
[951860.378396]        <ffffffff802231f9>{path_release+39} 
<ffffffff80209e9d>{__link_path_walk+3776}
[951860.379167]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80216228>{get_unused_fd+248}
[951860.379944]        <ffffffff8041e85f>{verify_iovec+75} 
<ffffffff80216c08>{sys_select+710}
[951860.380715]        <ffffffff8023d889>{remove_wait_queue+64} 
<ffffffff8022885d>{do_wait+2769}
[951860.381486]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80262222>{system_call+126}
[951860.382540] afpd          S ffff8100ebe85a48     0  9910      1 
3856   11332  9901 (NOTLB)
[951860.383477] ffff8100ebe85a48 ffffffff8055e140 00002ac335f21000 
ffff810000000000
[951860.383962]        ffff8100e8e56908 0000000000000001 
0000000000000000 00000000ebe85b88
[951860.384778]        0000000000003fd2 000361b14e0ec962
[951860.385245] Call Trace: <ffffffff802665a4>{schedule_timeout+34}
[951860.385726]        <ffffffff80213e2a>{tcp_poll+43} 
<ffffffff80211080>{do_select+1099}
[951860.386497]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.387268]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.388044]        <ffffffff80267afe>{_read_unlock+9} 
<ffffffff802126ca>{sock_def_readable+106}
[951860.388818]        <ffffffff804574bf>{unix_dgram_sendmsg+985} 
<ffffffff80258cea>{sock_sendmsg+235}
[951860.389592]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.390355]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.391127]        <ffffffff8023d889>{remove_wait_queue+64} 
<ffffffff8022885d>{do_wait+2769}
[951860.391898]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80231392>{sys_rt_sigprocmask+91}
[951860.392669]        <ffffffff80262222>{system_call+126}
[951860.393370] retroclient   S ffff8100be483ee8     0 11332      1 
11333   32490  9910 (NOTLB)
[951860.394304] ffff8100be483ee8 ffff810100086100 ffff8100a3366498 
000361b5fdac2d59
[951860.394789]        ffff810100070000 ffff81010002d340 
0000000000000001 00000001be483ef8
[951860.395606]        0000000000000260 000361b5fdac42bd
[951860.396075] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.396910]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8026664e>{schedule_timeout_interruptible+25}
[951860.397687]        <ffffffff802a22ea>{compat_sys_nanosleep+175} 
<ffffffff80264206>{ia32_sysret+0}
[951860.398735] retroclient   S ffff810178cc1b28     0 11333  11332 
11335               (NOTLB)
[951860.399672] ffff810178cc1b28 ffff8100f7c868a0 ffffffff8020785f 
000361b5c7ac4597
[951860.400156]        ffff810100070000 ffff81010002d340 
0000000000000001 0000000178cc1b38
[951860.400974]        00000000000004ca 000361b5c7ac7583
[951860.401443] Call Trace: <ffffffff8020785f>{_raw_spin_lock+146} 
<ffffffff8021d023>{__mod_timer+179}
[951860.402272]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.403044]        <ffffffff80230770>{do_sys_poll+783} 
<ffffffff8021b07c>{bad_range+26}
[951860.403814]        <ffffffff8020a121>{get_page_from_freelist+627} 
<ffffffff8021b07c>{bad_range+26}
[951860.404580]        <ffffffff8020a24a>{get_page_from_freelist+924} 
<ffffffff8021b07c>{bad_range+26}
[951860.405351]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.406123]        <ffffffff80292e86>{__sigqueue_alloc+66} 
<ffffffff80254b7c>{wake_up_state+11}
[951860.406895]        <ffffffff80293326>{signal_wake_up+36} 
<ffffffff80293a1b>{__group_complete_signal+611}
[951860.407666]        <ffffffff8025ede7>{group_send_sig_info+108} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951860.408441]        <ffffffff80265b94>{thread_return+101} 
<ffffffff8024f5fe>{sys_kill+311}
[951860.409212]        <ffffffff8024f3f5>{sys_poll+73} 
<ffffffff80264206>{ia32_sysret+0}
[951860.410257] retroclient   S ffff810178fabee8     0 11335  11333 
11336       (NOTLB)
[951860.411194] ffff810178fabee8 ffff810178fabe28 ffffffff80419503 
ffff810178fabe48
[951860.411679]        ffffffff8023e882 ffff81010002d340 
0000000000000001 0000000178fabef8
[951860.412498]        0000000000002a61 000361b3dab2d8e2
[951860.412967] Call Trace: <ffffffff80419503>{sock_destroy_inode+20}
[951860.413444]        <ffffffff8023e882>{destroy_inode+54} 
<ffffffff8021d023>{__mod_timer+179}
[951860.414216]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.414988]        <ffffffff8026664e>{schedule_timeout_interruptible+25}
[951860.415415]        <ffffffff802a22ea>{compat_sys_nanosleep+175} 
<ffffffff80264206>{ia32_sysret+0}
[951860.416462] retroclient   S ffff810178fadd48     0 11336  11333 
11337 11335 (NOTLB)
[951860.417401] ffff810178fadd48 ffff810100086100 ffff810178fadd28 
ffff81016ad73b20
[951860.417883]        0000000078fade09 0000000000000000 
0000000000000000 0000000178fadd18
[951860.418692]        00000000000006d5 00031e4a169fee7c
[951860.419157] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.419986]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.420750]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.421521]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.422296]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.423062]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.423831]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff80284780>{restore_i387_ia32+66}
[951860.424605] 
<ffffffff8027ef9d>{ia32_restore_sigcontext+433} 
<ffffffff8042c29f>{compat_sys_socketcall+141}
[951860.425394]        <ffffffff80264206>{ia32_sysret+0}
[951860.426091] retroclient   S ffff810178fafae8     0 11337  11333 
11344 11336 (NOTLB)
[951860.427029] ffff810178fafae8 ffff810178fafab8 ffff810037e82e08 
0000000000000001
[951860.427515]        0000000000000000 0000000000000000 
0000000000000001 0000000100000001
[951860.428331]        000000000000179b 000001a9dbe59c8b
[951860.428799] Call Trace: <ffffffff80421da2>{netdev_run_todo+39} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951860.429638]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8024add1>{prepare_to_wait_exclusive+95}
[951860.430417]        <ffffffff802593cc>{skb_recv_datagram+439} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.431195]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80231e6f>{release_sock+191}
[951860.431968]        <ffffffff80446e70>{udp_recvmsg+102} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951860.432738]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff8028696c>{__activate_task+31}
[951860.433504]        <ffffffff80249c05>{try_to_wake_up+982} 
<ffffffff80292e86>{__sigqueue_alloc+66}
[951860.434279]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80293326>{signal_wake_up+36}
[951860.435053] 
<ffffffff80293a1b>{__group_complete_signal+611} 
<ffffffff8022c8e7>{sys_recvfrom+184}
[951860.435830]        <ffffffff8025ede7>{group_send_sig_info+108} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951860.436604]        <ffffffff80265b94>{thread_return+101} 
<ffffffff8024f5fe>{sys_kill+311}
[951860.437378]        <ffffffff8042c31c>{compat_sys_socketcall+266} 
<ffffffff80264206>{ia32_sysret+0}
[951860.438428] retroclient   S ffff8101775ffd48     0 11344  11333 
11345 11337 (NOTLB)
[951860.439365] ffff8101775ffd48 0000000000000000 ffff8101775ffd28 
ffff81017dce41a0
[951860.439848]        00000000775ffe09 0000000000000000 
0000000000000000 00000001775ffd18
[951860.440664]        0000000000003c09 000001ab4199ba36
[951860.441133] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.441960]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.442727]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.443494]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.444269]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.445042]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.445815]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.446583]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff8044bea2>{inet_listen+109}
[951860.447341]        <ffffffff8042c29f>{compat_sys_socketcall+141} 
<ffffffff80264206>{ia32_sysret+0}
[951860.448391] retroclient   S ffff8101779b5ae8     0 11345  11333 
11352 11344 (NOTLB)
[951860.449326] ffff8101779b5ae8 ffff810037f7a5c0 ffff8100f761d2f8 
ffff81017a6c9fb0
[951860.449808]        0000000000000000 ffff8101779b5a78 
0000000000000001 000000017a6c9fa8
[951860.456738]        00000000000039d8 000001ab419d093d
[951860.457206] Call Trace: <ffffffff80421da2>{netdev_run_todo+39} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951860.458044]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8024add1>{prepare_to_wait_exclusive+95}
[951860.458822]        <ffffffff802593cc>{skb_recv_datagram+439} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.459597]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80231e6f>{release_sock+191}
[951860.460371]        <ffffffff80446e70>{udp_recvmsg+102} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951860.461137]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff80266b9f>{__mutex_lock_slowpath+785}
[951860.461913]        <ffffffff80221867>{generic_file_aio_write+116} 
<ffffffff80267ae8>{_spin_unlock+9}
[951860.462683] 
<ffffffff80266e89>{__mutex_unlock_slowpath+466} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.463462]        <ffffffff802e964c>{ext3_file_write+28} 
<ffffffff80218600>{do_sync_write+237}
[951860.464228]        <ffffffff8022c8e7>{sys_recvfrom+184} 
<ffffffff8043913d>{compat_ip_setsockopt+41}
[951860.464997]        <ffffffff804471c9>{compat_udp_setsockopt+14} 
<ffffffff8041c5b5>{compat_sock_common_setsockopt+24}
[951860.465773]        <ffffffff8042c31c>{compat_sys_socketcall+266} 
<ffffffff80264206>{ia32_sysret+0}
[951860.466825] retroclient   S ffff810170205d48     0 11352  11333 
11353 11345 (NOTLB)
[951860.467762] ffff810170205d48 0000000000000000 ffff810170205d28 
ffff81017aa68660
[951860.468244]        0000000070205e09 0000000000000000 
0000000000000000 0000000170205d18
[951860.469060]        000000000000350f 000001aca759000d
[951860.469529] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.470356]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.471125]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.471889]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.472664]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.473435]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.474204]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.474969]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff8044bea2>{inet_listen+109}
[951860.475735]        <ffffffff8042c29f>{compat_sys_socketcall+141} 
<ffffffff80264206>{ia32_sysret+0}
[951860.476780] retroclient   S ffff8101031b5ae8     0 11353  11333 
11360 11352 (NOTLB)
[951860.477717] ffff8101031b5ae8 ffff810037f7a5c0 ffff8100f761d2f8 
ffff81017a6c9320
[951860.478200]        0000000000000000 ffff8101031b5a78 
0000000000000001 000000017a6c9318
[951860.479018]        0000000000000ef3 000001aca75c7954
[951860.479485] Call Trace: <ffffffff80421da2>{netdev_run_todo+39} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951860.480324]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8024add1>{prepare_to_wait_exclusive+95}
[951860.481101]        <ffffffff802593cc>{skb_recv_datagram+439} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.481880]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80231e6f>{release_sock+191}
[951860.482655]        <ffffffff80446e70>{udp_recvmsg+102} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951860.483432]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff80266b9f>{__mutex_lock_slowpath+785}
[951860.484204]        <ffffffff80221867>{generic_file_aio_write+116} 
<ffffffff80267ae8>{_spin_unlock+9}
[951860.484976] 
<ffffffff80266e89>{__mutex_unlock_slowpath+466} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.485755]        <ffffffff802e964c>{ext3_file_write+28} 
<ffffffff80218600>{do_sync_write+237}
[951860.486524]        <ffffffff8022c8e7>{sys_recvfrom+184} 
<ffffffff8043913d>{compat_ip_setsockopt+41}
[951860.487294]        <ffffffff804471c9>{compat_udp_setsockopt+14} 
<ffffffff8041c5b5>{compat_sock_common_setsockopt+24}
[951860.488075]        <ffffffff8042c31c>{compat_sys_socketcall+266} 
<ffffffff80264206>{ia32_sysret+0}
[951860.489120] retroclient   S ffff81016ee4fd48     0 11360  11333 
11365 11353 (NOTLB)
[951860.490051] ffff81016ee4fd48 ffff81016ee4fd68 ffff81016ee4fd28 
ffff8100f7f6b400
[951860.490529]        000000006ee4fe09 0000000000000000 
0000000000000000 000000006ee4fd18
[951860.491345]        000000000000077a 00031e49bf653876
[951860.491813] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.492642]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.493412]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.494177]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.494950]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.495721]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.496491]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff80284780>{restore_i387_ia32+66}
[951860.497266] 
<ffffffff8027ef9d>{ia32_restore_sigcontext+433} 
<ffffffff8042c29f>{compat_sys_socketcall+141}
[951860.498056]        <ffffffff80264206>{ia32_sysret+0}
[951860.498753] retroclient   S ffff81016b62bee8     0 11365  11333 
14374 11360 (NOTLB)
[951860.499689] ffff81016b62bee8 ffff810100086100 0000000000000000 
000361b5fd6f3da8
[951860.500171]        ffff810100070000 ffff81010002d340 
0000000000000001 000000016b62bef8
[951860.500989]        00000000000002ba 000361b5fd6f563a
[951860.501459] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.502291]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8026664e>{schedule_timeout_interruptible+25}
[951860.503067]        <ffffffff802a22ea>{compat_sys_nanosleep+175} 
<ffffffff80264206>{ia32_sysret+0}
[951860.504110] cnid_dbd      S ffff81006dc21a48     0 11908   9901 
27918       (NOTLB)
[951860.505043] ffff81006dc21a48 ffff810100086100 0000000000000001 
000361b5ee337909
[951860.505524]        0000000000070000 0000000000000000 
ffff810100070000 000000016dc21a58
[951860.506340]        0000000000000900 000361b5ee33ca09
[951860.506810] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.507644]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.508417]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.509185]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.509965]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.510743]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.511526]        <ffffffff80216c08>{sys_select+710} 
<ffffffff802fb179>{journal_force_commit+35}
[951860.512301]        <ffffffff802f3c8e>{ext3_force_commit+38} 
<ffffffff8025386d>{do_fsync+132}
[951860.513070]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80262222>{system_call+126}
[951860.514124] smbd          S ffff81003f3efa48     0  8270   9544 
10289  9548 (NOTLB)
[951860.515061] ffff81003f3efa48 ffff810100086100 0000000000000297 
000361a956e052cc
[951860.515544]        ffff810100070000 ffff81010002d340 
0000000000000001 000000013f3efa58
[951860.516360]        000000000000396b 000361a956e25792
[951860.516827] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.517657]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.518421]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.519183]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951860.519962]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951860.520741]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951860.521518]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff802121ff>{poison_obj+58}
[951860.522288]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff80216c08>{sys_select+710}
[951860.523062]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951860.524113] smbd          D ffff810093d97348     0 10289   9544 
31891  8270 (NOTLB)
[951860.525049] ffff810093d97348 ffff8101421f1180 0000000000011200 
0000000000000010
[951860.525533]        0000000000000001 0000000000000000 
0000000000000000 0000000000000000
[951860.526348]        000000000000011e 00035d4558d4560e
[951860.526816] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951860.527671]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951860.534561]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951860.535340]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951860.535772]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951860.536539]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951860.537309]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951860.538092]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951860.538857] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951860.539629]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951860.540417]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951860.541190]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff8807dff4>{:ip_conntrack:tcp_packet+3069}
[951860.541982]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951860.542754]        <ffffffff8021612b>{alloc_pages_current+126} 
<ffffffff802a9cfc>{page_cache_alloc_cold+29}
[951860.543526] 
<ffffffff802124d1>{__do_page_cache_readahead+182} 
<ffffffff8021ea22>{__pollwait+0}
[951860.544312]        <ffffffff80233c98>{blockable_page_cache_readahead+93}
[951860.544734]        <ffffffff8022fced>{make_ahead_window+137} 
<ffffffff802143e9>{page_cache_readahead+393}
[951860.545504] 
<ffffffff8020b957>{do_generic_mapping_read+316} 
<ffffffff8020cbf5>{file_read_actor+0}
[951860.546284] 
<ffffffff8020bdcb>{__generic_file_aio_read+371} 
<ffffffff802171f3>{generic_file_aio_read+54}
[951860.547057]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff80241d9b>{locks_free_lock+92}
[951860.547828]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8020ae40>{vfs_read+175}
[951860.548603]        <ffffffff80213834>{sys_pread64+88} 
<ffffffff80262222>{system_call+126}
[951860.549649] smbd          S ffff810132ebfa48     0 31891   9544 
29010 10289 (NOTLB)
[951860.550585] ffff810132ebfa48 ffffffff8055e140 ffffffff80267afe 
000361b1a5625f84
[951860.551067]        ffffffff806825c0 ffff81000c005340 
0000000000000000 0000000032ebfa58
[951860.551883]        00000000000029a0 000361b1a563d62a
[951860.552353] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff8021d023>{__mod_timer+179}
[951860.553180]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.553950]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.554718]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.555498]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.556290]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff80209d31>{__link_path_walk+3412}
[951860.557065]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.557838]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951860.558607]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.559383]        <ffffffff80262222>{system_call+126}
[951860.560078] smbd          D ffff81006fd85348     0 29010   9544 
24530 31891 (NOTLB)
[951860.561007] ffff81006fd85348 ffff8101150997e0 0000000000011200 
0000000000000010
[951860.561484]        0000000000000001 0000000000000000 
0000000000000000 0000000000000000
[951860.562296]        00000000000000ef 00035d4558d441b9
[951860.562764] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951860.563620]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951860.564398]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951860.565177]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951860.565609]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951860.566377]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951860.567149]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951860.567933]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951860.568700] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951860.569471]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951860.570247]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951860.571020]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff80369efa>{pci_bus_read_config_dword+106}
[951860.571796]        <ffffffff8027b266>{gart_map_simple+64} 
<ffffffff80267ae8>{_spin_unlock+9}
[951860.572563]        <ffffffff88040ed1>{:tg3:tg3_start_xmit_dma_bug+1667}
[951860.572997]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951860.573773]        <ffffffff8021612b>{alloc_pages_current+126} 
<ffffffff802a9cfc>{page_cache_alloc_cold+29}
[951860.574544] 
<ffffffff802124d1>{__do_page_cache_readahead+182} 
<ffffffff8021ea22>{__pollwait+0}
[951860.575319]        <ffffffff80233c98>{blockable_page_cache_readahead+93}
[951860.575739]        <ffffffff8022fced>{make_ahead_window+137} 
<ffffffff802143e9>{page_cache_readahead+393}
[951860.576506] 
<ffffffff8020b957>{do_generic_mapping_read+316} 
<ffffffff8020cbf5>{file_read_actor+0}
[951860.577288] 
<ffffffff8020bdcb>{__generic_file_aio_read+371} 
<ffffffff802171f3>{generic_file_aio_read+54}
[951860.578070]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff80241d9b>{locks_free_lock+92}
[951860.578844]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8020ae40>{vfs_read+175}
[951860.579621]        <ffffffff80213834>{sys_pread64+88} 
<ffffffff80262222>{system_call+126}
[951860.580669] smbd          S ffff8100c245da48     0 24530   9544 
8543 29010 (NOTLB)
[951860.581607] ffff8100c245da48 ffffffff8055e140 ffffffff802eba75 
000361af69e35300
[951860.582090]        ffffffff806825c0 ffff81000c005340 
0000000000000000 00000000c245da58
[951860.582910]        00000000000007eb 000361af69e39a46
[951860.583377] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951860.583854]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.584622]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.585395]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.586167]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8020de0b>{current_fs_time+79}
[951860.586946]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951860.587722]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff80221867>{generic_file_aio_write+116}
[951860.588496]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80266e89>{__mutex_unlock_slowpath+466}
[951860.589260]        <ffffffff80266eb1>{mutex_unlock+13} 
<ffffffff80221867>{generic_file_aio_write+116}
[951860.590040]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.590810]        <ffffffff80262222>{system_call+126}
[951860.591507] pdflush       S ffff81003af55eb8     0 32250     11 
19751  9307 (L-TLB)
[951860.592444] ffff81003af55eb8 ffffffff8029b2e7 ffff81003af55df0 
ffff81003af55df0
[951860.592927]        ffffffff80254b69 0000000000000001 
0000000000000000 000000003af55ec8
[951860.593743]        00000000000000a4 00034ecf445b7711
[951860.594209] Call Trace: <ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.594689]        <ffffffff80254b69>{writeback_inodes+234} 
<ffffffff8025a802>{pdflush+0}
[951860.595459]        <ffffffff8025a8e6>{pdflush+228} 
<ffffffff8023420c>{kthread+208}
[951860.596230]        <ffffffff8026331a>{child_rip+8} 
<ffffffff8023413c>{kthread+0}
[951860.596993]        <ffffffff80263312>{child_rip+0}
[951860.597686] pdflush       D ffff8100ccc2d818     0 19751     11 
27168 32250 (L-TLB)
[951860.598623] ffff8100ccc2d818 ffff810037fe6080 ffff81000cca4708 
ffff810037ea6ee0
[951860.599106]        0000000000000282 0000000000000000 
0000000000000000 0000000000000093
[951860.599921]        00000000000000dc 00035d4558d42eed
[951860.600390] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951860.601247]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951860.602024]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951860.602802]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951860.603233]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951860.603993]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951860.604756]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951860.605539]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951860.612430] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951860.613200]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951860.613990]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff8021d3c3>{mpage_writepages+549}
[951860.614761]        <ffffffff802c2ce7>{blkdev_writepage+0} 
<ffffffff802c2a45>{generic_writepages+11}
[951860.615532]        <ffffffff8025f475>{do_writepages+41} 
<ffffffff80230cf3>{__writeback_single_inode+503}
[951860.616313]        <ffffffff80287357>{find_busiest_group+304} 
<ffffffff8029dd1e>{debug_mutex_add_waiter+147}
[951860.617099]        <ffffffff80220f6d>{sync_sb_inodes+477} 
<ffffffff80254b1d>{writeback_inodes+158}
[951860.617862]        <ffffffff8025a802>{pdflush+0} 
<ffffffff802acdef>{wb_kupdate+142}
[951860.618623]        <ffffffff8025a96b>{pdflush+361} 
<ffffffff802acd61>{wb_kupdate+0}
[951860.619383]        <ffffffff8023420c>{kthread+208} 
<ffffffff8026331a>{child_rip+8}
[951860.620150]        <ffffffff8023413c>{kthread+0} 
<ffffffff80263312>{child_rip+0}
[951860.621193] afpd          S ffff810016949b98     0  3856   9910 
11364       (NOTLB)
[951860.622130] ffff810016949b98 ffff81003c319e00 000000000000000e 
ffff810016949b18
[951860.622611]        ffffffff802327ca 0000000000000008 
0000000000000000 0000000000047580
[951860.623427]        000000000000058c 000361b3738cd833
[951860.623894] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951860.624379]        <ffffffff80227d88>{kfree_skbmem+126} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.625148]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.625915]        <ffffffff8041bafd>{sk_wait_data+149} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.626693]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80231e6f>{release_sock+191}
[951860.627466]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951860.628240]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951860.629009]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff8020c99c>{do_sync_read+237}
[951860.629780]        <ffffffff80263161>{error_exit+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.630553]        <ffffffff8020ae53>{vfs_read+194} 
<ffffffff8021122a>{sys_read+71}
[951860.631319]        <ffffffff80262222>{system_call+126}
[951860.632018] smbd          S ffff810058dafa48     0  8543   9544 
22538 24530 (NOTLB)
[951860.632947] ffff810058dafa48 ffff810100086100 ffffffff80267afe 
000361b50e385b7c
[951860.633433]        ffff810100070000 ffff81010002d340 
0000000000000001 0000000158dafa58
[951860.634250]        00000000000010c0 000361b50e38f242
[951860.634718] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff8021d023>{__mod_timer+179}
[951860.635544]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.636319]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.637087]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.637866]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.638641]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff80209d31>{__link_path_walk+3412}
[951860.639416]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.640188]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951860.640958]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.641735]        <ffffffff80262222>{system_call+126}
[951860.642430] afpd          S ffff81000e463b98     0 11364   9910 
27917  3856 (NOTLB)
[951860.643367] ffff81000e463b98 ffff8100598f8e00 000000000000000e 
ffff81000e463b18
[951860.643847]        ffffffff802327ca 0000000000000004 
0000000000000000 0000000000047580
[951860.644663]        000000000000068c 000361b4afcc63df
[951860.645131] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951860.645617]        <ffffffff80227d88>{kfree_skbmem+126} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.646387]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.647144]        <ffffffff8041bafd>{sk_wait_data+149} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.647917]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80231e6f>{release_sock+191}
[951860.648691]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951860.649463]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951860.650235]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff8020c99c>{do_sync_read+237}
[951860.651007]        <ffffffff80263161>{error_exit+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.651782]        <ffffffff8020ae53>{vfs_read+194} 
<ffffffff8021122a>{sys_read+71}
[951860.652548]        <ffffffff80262222>{system_call+126}
[951860.653251] afpd          S ffff810074501b98     0 27917   9910 
32105 11364 (NOTLB)
[951860.654187] ffff810074501b98 ffff810053b1da20 000000000000000a 
ffff810074501b18
[951860.654668]        ffffffff802327ca 0000000000000008 
0000000000000000 0000000000047580
[951860.655484]        000000000000052e 000361b2e76f15a6
[951860.655954] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951860.656432]        <ffffffff80227d88>{kfree_skbmem+126} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.657201]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.657965]        <ffffffff8041bafd>{sk_wait_data+149} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.658742]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80231e6f>{release_sock+191}
[951860.659517]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951860.660287]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951860.661050]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff8020c99c>{do_sync_read+237}
[951860.661814]        <ffffffff80263161>{error_exit+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.662587]        <ffffffff8020ae53>{vfs_read+194} 
<ffffffff8021122a>{sys_read+71}
[951860.663352]        <ffffffff80262222>{system_call+126}
[951860.664052] cnid_dbd      S ffff8100c0441a48     0 27918   9901 
6947 11908 (NOTLB)
[951860.664990] ffff8100c0441a48 ffff8100ebf3f040 ffff8100ebe42428 
000361b5ee33ca09
[951860.665474]        ffff810100070000 ffff81010002d340 
0000000000000001 00000001c0441a58
[951860.666291]        00000000000006e8 000361b5ee340f1f
[951860.666759] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.667587]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.668359]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.669129]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.669907]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.670687]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80265b94>{thread_return+101}
[951860.671462]        <ffffffff80216c08>{sys_select+710} 
<ffffffff802fb179>{journal_force_commit+35}
[951860.672238]        <ffffffff802f3c8e>{ext3_force_commit+38} 
<ffffffff8025386d>{do_fsync+132}
[951860.673005]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80262222>{system_call+126}
[951860.674068] smbd          S ffff8100e5b2ba48     0 22538   9544 
12830  8543 (NOTLB)
[951860.674998] ffff8100e5b2ba48 ffff8100e5b2b9c8 ffffffff802eba75 
0000000000000127
[951860.675475]        ffff8100a43bfc80 ffff81010002d340 
0000000000000001 00000001e5b2ba58
[951860.676287]        0000000000008797 000361abd1f1933d
[951860.676755] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951860.677232]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.678004]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.678775]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.679546]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8020de0b>{current_fs_time+79}
[951860.680323]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951860.681099]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff80221867>{generic_file_aio_write+116}
[951860.681872]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80266e89>{__mutex_unlock_slowpath+466}
[951860.682662]        <ffffffff80266eb1>{mutex_unlock+13} 
<ffffffff80221867>{generic_file_aio_write+116}
[951860.683450]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.690337]        <ffffffff80262222>{system_call+126}
[951860.691033] smbd          S ffff81008c8a5a48     0 12830   9544 
17962 22538 (NOTLB)
[951860.691970] ffff81008c8a5a48 ffff810100086100 ffffffff80267afe 
000361a92ea6706f
[951860.692453]        ffff810100070000 ffff81010002d340 
0000000000000001 000000018c8a5a58
[951860.693267]        0000000000001356 000361a92ea71e7a
[951860.693733] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff8021d023>{__mod_timer+179}
[951860.694559]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.695331]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.696096]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.696877]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.697651]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff80209d31>{__link_path_walk+3412}
[951860.698426]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.699216]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951860.699984]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.700760]        <ffffffff80262222>{system_call+126}
[951860.701473] smbd          S ffff8100c0c79a48     0 17962   9544 
23331 12830 (NOTLB)
[951860.702411] ffff8100c0c79a48 ffffffff8055e140 ffffffff80267afe 
000361afdba9e09f
[951860.702892]        ffffffff806825c0 ffff81000c005340 
0000000000000000 00000000c0c79a58
[951860.703700]        0000000000000803 000361afdbaa28ba
[951860.704165] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff8021d023>{__mod_timer+179}
[951860.704987]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.705763]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.706530]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.707310]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.708084]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff80209d31>{__link_path_walk+3412}
[951860.708858]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.709630]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951860.710401]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.711178]        <ffffffff80262222>{system_call+126}
[951860.711875] smbd          S ffff810082119a48     0 23331   9544 
28361 17962 (NOTLB)
[951860.712813] ffff810082119a48 ffff810100086100 0000000000000297 
000361b123e660f8
[951860.713293]        ffff810100070000 ffff81010002d340 
0000000000000001 0000000182119a58
[951860.714112]        0000000000001418 000361b123e715d0
[951860.714580] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.715409]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.716182]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.716949]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951860.717723]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951860.718493]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951860.719264]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff802121ff>{poison_obj+58}
[951860.720035]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff80216c08>{sys_select+710}
[951860.720810]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951860.721864] smbd          S ffff810158549a48     0 28361   9544 
3404 23331 (NOTLB)
[951860.722801] ffff810158549a48 ffff810158549988 ffffffff80267afe 
ffff8101585499d8
[951860.723286]        ffffffff880ba1b4 ffff81000c005340 
0000000000000000 0000000058549a58
[951860.724102]        0000000000001157 000361af119556e9
[951860.724571] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff880ba1b4>{:bonding:bond_alb_xmit+1114}
[951860.725417]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.726187]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.726959]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.727728]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951860.728501]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951860.729271] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.730043]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951860.730813]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951860.731580]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951860.732345]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.733109]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951860.734161] bash          S ffff810083a3fe98     0 28411      1 
6499    8482  6332 (NOTLB)
[951860.735098] ffff810083a3fe98 ffff810083a3fdd8 ffffffff80287dc4 
ffff810083a3fdf8
[951860.735580]        000000008029b2f6 0000000000000000 
ffff8100e8ad9088 0000000000000202
[951860.736396]        000000000000991a 00034f9b31b58587
[951860.736865] Call Trace: <ffffffff80287dc4>{default_wake_function+13}
[951860.737345]        <ffffffff8022258c>{__up_read+147} 
<ffffffff80228826>{do_wait+2714}
[951860.738115]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951860.738884]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8025845f>{sys_wait4+40}
[951860.739657]        <ffffffff80262222>{system_call+126}
[951860.740364] smbd          S ffff81010e68da48     0  3404   9544 
13660 28361 (NOTLB)
[951860.741302] ffff81010e68da48 ffff81010e68d9c8 ffffffff802eba75 
0000000000000039
[951860.741784]        ffff8100a43bfc80 ffff81000c005340 
0000000000000000 000000000e68da58
[951860.742603]        0000000000007580 000361a9f19b7961
[951860.743072] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951860.743553]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.744321]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.745092]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.745860]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8020de0b>{current_fs_time+79}
[951860.746631]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951860.747417]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff80221867>{generic_file_aio_write+116}
[951860.748188]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80266e89>{__mutex_unlock_slowpath+466}
[951860.748963]        <ffffffff80266eb1>{mutex_unlock+13} 
<ffffffff80221867>{generic_file_aio_write+116}
[951860.749739]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.750516]        <ffffffff80262222>{system_call+126}
[951860.751214] smbd          S ffff81012cde9a48     0 13660   9544 
25449  3404 (NOTLB)
[951860.752151] ffff81012cde9a48 0000000000000000 0000000000000297 
ffff81012cde99b8
[951860.752631]        ffffffff80230a81 ffff81000c005340 
0000000000000000 000000002cde9a58
[951860.753448]        0000000000001c7c 000361ac85ca4d36
[951860.753917] Call Trace: <ffffffff80230a81>{dev_queue_xmit+527} 
<ffffffff8021d023>{__mod_timer+179}
[951860.754745]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.755519]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.756285]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.757063]        <ffffffff8024b433>{mod_timer+43} 
<ffffffff80258fae>{sk_reset_timer+21}
[951860.757832]        <ffffffff8023c1af>{update_send_head+137} 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050}
[951860.758611]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.759380]        <ffffffff80226c0a>{tcp_sendmsg+2555} 
<ffffffff802fa0ca>{ext3_permission+16}
[951860.760148]        <ffffffff80209127>{__link_path_walk+330} 
<ffffffff802480ed>{inet_sendmsg+70}
[951860.760927]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951860.761693]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.768581]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80262222>{system_call+126}
[951860.769641] kjournald     S ffff810011725e68     0 27168     11 
19751 (L-TLB)
[951860.770576] ffff810011725e68 000000008055e140 ffff810011725e78 
000003cc00000000
[951860.771056]        00000000734ec434 0000000000000000 
ffff81008c87eb08 00000000395e2e50
[951860.771871]        00000000000003bc 00032de757452795
[951860.772340] Call Trace: <ffffffff802ffdee>{kjournald+455} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.773178]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802ffc27>{kjournald+0}
[951860.773950]        <ffffffff8023420c>{kthread+208} 
<ffffffff8026331a>{child_rip+8}
[951860.774711]        <ffffffff8023413c>{kthread+0} 
<ffffffff80263312>{child_rip+0}
[951860.775743] smbd          S ffff81014f81ba48     0 25449   9544 
28328 13660 (NOTLB)
[951860.776680] ffff81014f81ba48 ffffffff8055e140 ffffffff80267afe 
000361aa527791b0
[951860.777162]        ffffffff806825c0 ffff81000c005340 
0000000000000000 000000004f81ba58
[951860.777978]        0000000000001cc6 000361aa527894a6
[951860.778447] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff8021d023>{__mod_timer+179}
[951860.779270]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.780046]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.780811]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.781592]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.782367]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff80209d31>{__link_path_walk+3412}
[951860.783142]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.783913]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951860.784683]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.785460]        <ffffffff80262222>{system_call+126}
[951860.786155] smbd          S ffff810166ab7a48     0 28328   9544 
2091 25449 (NOTLB)
[951860.787093] ffff810166ab7a48 ffff810100086100 ffffffff80267afe 
000361aa6451dc51
[951860.787575]        ffff810100070000 ffff81010002d340 
0000000000000001 0000000166ab7a58
[951860.788391]        00000000000010ae 000361aa64527277
[951860.788857] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff8021d023>{__mod_timer+179}
[951860.789675]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.790448]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.791215]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.791995]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.792771]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff80209d31>{__link_path_walk+3412}
[951860.793546]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951860.794317]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951860.795088]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.795865]        <ffffffff80262222>{system_call+126}
[951860.796563] apache2       S ffff8100691c9a48     0 32490      1 
24761   27973 11332 (NOTLB)
[951860.797500] ffff8100691c9a48 ffff8100eb472760 ffffffff8020785f 
000361b61632bc50
[951860.797980]        ffff810100070000 ffff81010002d340 
0000000000000001 00000001691c9a58
[951860.798798]        000000000000042e 000361b61632e61f
[951860.799267] Call Trace: <ffffffff8020785f>{_raw_spin_lock+146} 
<ffffffff8021d023>{__mod_timer+179}
[951860.800101]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.800871]        <ffffffff80211080>{do_select+1099} 
<ffffffff802f3a53>{__ext3_journal_stop+38}
[951860.801644]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80223ca4>{__pagevec_free+46}
[951860.802415]        <ffffffff8021b07c>{bad_range+26} 
<ffffffff8020a121>{get_page_from_freelist+627}
[951860.803185]        <ffffffff8020eea6>{__alloc_pages+105} 
<ffffffff80216c08>{sys_select+710}
[951860.803954]        <ffffffff8023d889>{remove_wait_queue+64} 
<ffffffff8022885d>{do_wait+2769}
[951860.804719]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80262222>{system_call+126}
[951860.805774] apache2       S ffff81015b1fbd58     0 24761  32490 
24764       (NOTLB)
[951860.806709] ffff81015b1fbd58 0000000000000286 ffff810000010d10 
00000000000200d2
[951860.807189]        00000000000200d2 ffff810000010d10 
0000000000000000 000000005b1fbd08
[951860.808006]        0000000000002cf5 0002909f86b9b417
[951860.808474] Call Trace: <ffffffff8021aa83>{vsnprintf+1419} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.809307] 
<ffffffff8024add1>{prepare_to_wait_exclusive+95} 
<ffffffff802593cc>{skb_recv_datagram+439}
[951860.810088]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.810870]        <ffffffff80456f04>{unix_accept+101} 
<ffffffff8041a03c>{sys_accept+260}
[951860.811640]        <ffffffff80292d92>{switch_uid+52} 
<ffffffff80262222>{system_call+126}
[951860.812690] apache2       S ffff8101298b9d88     0 24764  32490 
24765 24761 (NOTLB)
[951860.813631] ffff8101298b9d88 ffffffff80000000 ffff8101298b9d68 
ffff8100c2fbf1a0
[951860.814113]        ffff8101298b9e49 00000000ffffffff 
0000000000000000 00000000298b9d58
[951860.814930]        0000000000001b0d 00030a214213c6a0
[951860.815398] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.816226]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.816997]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.817755]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.818522]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.819294]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.820064]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff802c513f>{pipe_read+28}
[951860.820835]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.821604]        <ffffffff80262222>{system_call+126}
[951860.822300] apache2       S ffff81016ad8bd88     0 24765  32490 
24766 24764 (NOTLB)
[951860.823240] ffff81016ad8bd88 ffffffff80000000 ffff81016ad8bd68 
ffff810106c49660
[951860.823723]        ffff81016ad8be49 00000000ffffffff 
0000000000000001 000000016ad8bd58
[951860.824539]        0000000000001eb4 00030a21415d4895
[951860.825008] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.825835]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.826603]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.827368]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.828141]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.828913]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.829681]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff802c513f>{pipe_read+28}
[951860.830452]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.831223]        <ffffffff80262222>{system_call+126}
[951860.831914] apache2       S ffff81015bb69d88     0 24766  32490 
24767 24765 (NOTLB)
[951860.832845] ffff81015bb69d88 ffffffff80000000 ffff81015bb69d68 
ffff8101541d8400
[951860.833328]        ffff81015bb69e49 00000000ffffffff 
0000000000000001 000000015bb69d58
[951860.834145]        0000000000002afb 0002f8981fc0293a
[951860.834613] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.835440]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.836208]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.836973]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.837745]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.838517]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.839287]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff802c513f>{pipe_read+28}
[951860.840062]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.846946]        <ffffffff80262222>{system_call+126}
[951860.847641] apache2       S ffff810113ee1d88     0 24767  32490 
24768 24766 (NOTLB)
[951860.848578] ffff810113ee1d88 ffffffff80000000 ffff810113ee1d68 
ffff8100d8d67660
[951860.849061]        ffff810113ee1e49 00000000ffffffff 
0000000000000000 0000000013ee1d58
[951860.849876]        0000000000001595 0002f8982169ba19
[951860.850344] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.851171]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.851947]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.852714]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.853488]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.854266]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.855036]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff802c513f>{pipe_read+28}
[951860.855808]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.856577]        <ffffffff80262222>{system_call+126}
[951860.857278] apache2       S ffff810150923d88     0 24768  32490 
21619 24767 (NOTLB)
[951860.858216] ffff810150923d88 ffffffff80000000 ffff810150923d68 
ffff8101625b8070
[951860.858698]        ffff810150923e49 00000000ffffffff 
0000000000000001 0000000150923d58
[951860.859518]        0000000000002034 0002f8907f3c8e95
[951860.859986] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.860807]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.861571]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.862337]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.863113]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.863884]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.864653]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff802c513f>{pipe_read+28}
[951860.865424]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.866196]        <ffffffff80262222>{system_call+126}
[951860.866895] smbd          S ffff81003d789a48     0  2091   9544 
10197 28328 (NOTLB)
[951860.867834] ffff81003d789a48 ffff81003d789988 ffffffff80267afe 
ffff81003d7899d8
[951860.868316]        ffffffff880ba1b4 ffff81010002d340 
0000000000000001 000000013d789a58
[951860.869135]        00000000000047c5 000361b54905a172
[951860.869604] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff880ba1b4>{:bonding:bond_alb_xmit+1114}
[951860.870440]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.871210]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.871980]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.872749]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951860.873524]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951860.874305] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.875071]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951860.875837]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951860.876608]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951860.877380]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.878157]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951860.879209] smbd          S ffff810120b0da48     0 10197   9544 
10832  2091 (NOTLB)
[951860.880147] ffff810120b0da48 ffff810120b0d9c8 ffffffff802eba75 
0000000000000303
[951860.880629]        ffff8100a43bfc80 ffff81000c005340 
0000000000000000 0000000020b0da58
[951860.881447]        00000000000061dd 000361b5f30234b0
[951860.881916] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951860.882398]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.883168]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.883940]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.884711]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8020de0b>{current_fs_time+79}
[951860.885489]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951860.886280]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff80221867>{generic_file_aio_write+116}
[951860.887052]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80266e89>{__mutex_unlock_slowpath+466}
[951860.887821]        <ffffffff80266eb1>{mutex_unlock+13} 
<ffffffff80221867>{generic_file_aio_write+116}
[951860.888605]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.889373]        <ffffffff80262222>{system_call+126}
[951860.890065] smbd          S ffff810107c3ba48     0 10832   9544 
15513 10197 (NOTLB)
[951860.891002] ffff810107c3ba48 ffff810100086100 0000000000000297 
000361b386ab91c9
[951860.891483]        ffff810100070000 ffff81010002d340 
0000000000000001 0000000107c3ba58
[951860.892301]        000000000000148c 000361b386ac4aba
[951860.892770] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.893601]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.894373]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.895144]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951860.895916]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951860.896688] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.897460]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951860.898229]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951860.899000]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951860.899770]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.900547]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951860.901600] smbd          S ffff81012f1f7a48     0 15513   9544 
19215 10832 (NOTLB)
[951860.902539] ffff81012f1f7a48 ffff81012f1f7988 ffffffff80267afe 
ffff81012f1f79d8
[951860.903018]        ffffffff880ba1b4 ffff81010002d340 
0000000000000001 000000012f1f7a58
[951860.903828]        000000000000248e 000361af71fc9817
[951860.904292] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff880ba1b4>{:bonding:bond_alb_xmit+1114}
[951860.905133]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.905914]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.906681]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.907450]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951860.908222]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951860.908995] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.909765]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951860.910535]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951860.911304]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951860.912075]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.912848]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951860.913901] smbd          S ffff810067393a48     0 19215   9544 
19585 15513 (NOTLB)
[951860.914839] ffff810067393a48 ffff810067393988 ffffffff80267afe 
ffff8100673939d8
[951860.915322]        ffffffff880ba1b4 ffff81000c005340 
0000000000000000 0000000067393a58
[951860.916139]        0000000000002530 000361aeec375dcc
[951860.916607] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff880ba1b4>{:bonding:bond_alb_xmit+1114}
[951860.917449]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.918210]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.925094]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.925863]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951860.926639]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951860.927411] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.928180]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951860.928949]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951860.929769]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951860.930539]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.931316]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951860.932357] smbd          S ffff8100e7315a48     0 19585   9544 
19761 19215 (NOTLB)
[951860.933292] ffff8100e7315a48 ffff810100086100 ffffffff80267afe 
000361aa00966b52
[951860.933775]        ffff810100070000 ffff81010002d340 
0000000000000001 00000001e7315a58
[951860.934591]        00000000000014ba 000361aa009725e4
[951860.935058] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff8021d023>{__mod_timer+179}
[951860.935883]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951860.936659]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951860.937433]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.938214]        <ffffffff8024b433>{mod_timer+43} 
<ffffffff80258fae>{sk_reset_timer+21}
[951860.938986]        <ffffffff8023c1af>{update_send_head+137} 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050}
[951860.939767]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.940557]        <ffffffff80226c0a>{tcp_sendmsg+2555} 
<ffffffff80209d31>{__link_path_walk+3412}
[951860.941333]        <ffffffff802480ed>{inet_sendmsg+70} 
<ffffffff80239408>{do_sock_write+163}
[951860.942102]        <ffffffff8024a41a>{sock_aio_write+87} 
<ffffffff802121ff>{poison_obj+58}
[951860.942872]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951860.943649]        <ffffffff80262222>{system_call+126}
[951860.944345] smbd          D ffff8100a233f368     0 19761   9544 
30680 19585 (NOTLB)
[951860.945282] ffff8100a233f368 ffff8101701d40c0 ffff8100757c4bb0 
ffff8100757c4bb0
[951860.945761]        0000000029dc0048 0000000000000000 
0000000000000000 0000000000000001
[951860.946568]        0000000000000104 00035d4558d47e22
[951860.947033] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951860.947892]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951860.948680]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951860.949456]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951860.949890]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951860.950658]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951860.951429]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951860.952209]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951860.952978] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951860.953750]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951860.954525]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951860.955298]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951860.956094]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff8021612b>{alloc_pages_current+126}
[951860.956867]        <ffffffff802a9cfc>{page_cache_alloc_cold+29} 
<ffffffff802124d1>{__do_page_cache_readahead+182}
[951860.957642]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff802121ff>{poison_obj+58}
[951860.958406]        <ffffffff80233c98>{blockable_page_cache_readahead+93}
[951860.958829]        <ffffffff80214340>{page_cache_readahead+224} 
<ffffffff8020b957>{do_generic_mapping_read+316}
[951860.959608]        <ffffffff8020cbf5>{file_read_actor+0} 
<ffffffff8020bdcb>{__generic_file_aio_read+371}
[951860.960383]        <ffffffff802171f3>{generic_file_aio_read+54} 
<ffffffff8020c99c>{do_sync_read+237}
[951860.961151]        <ffffffff80241d9b>{locks_free_lock+92} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.961926]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80265b94>{thread_return+101}
[951860.962701]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff80213834>{sys_pread64+88}
[951860.963466]        <ffffffff80262222>{system_call+126}
[951860.964165] apache2       S ffff81013fb89d88     0 21619  32490 
21620 24768 (NOTLB)
[951860.965102] ffff81013fb89d88 ffffffff80000000 ffff81013fb89d68 
ffff810138b76eb0
[951860.965584]        000000003fb89e49 0000000000000000 
0000000000000000 000000003fb89d58
[951860.966400]        0000000000004c4b 00030a0d73093a70
[951860.966870] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.967699]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.968467]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.969231]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.970006]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.970778]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.971550]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff802c513f>{pipe_read+28}
[951860.972320]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.973096]        <ffffffff80262222>{system_call+126}
[951860.973804] apache2       S ffff810124073d88     0 21620  32490 
21619 (NOTLB)
[951860.974734] ffff810124073d88 ffffffff80000000 ffff810124073d68 
ffff81003e4889f0
[951860.975212]        ffff810124073e49 00000000ffffffff 
0000000000000000 0000000024073d58
[951860.976025]        0000000000002156 0002f89080a9dd5a
[951860.976494] Call Trace: <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80234f79>{lock_sock+202}
[951860.977321]        <ffffffff80222bcf>{d_alloc+36} 
<ffffffff802665a4>{schedule_timeout+34}
[951860.978086]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951860.978849]        <ffffffff8043af17>{inet_csk_accept+202} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.979623]        <ffffffff80243e51>{d_rehash+130} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951860.980395]        <ffffffff804195fe>{sock_attach_fd+142} 
<ffffffff8044c1b7>{inet_accept+38}
[951860.981165]        <ffffffff8041a03c>{sys_accept+260} 
<ffffffff802c513f>{pipe_read+28}
[951860.981937]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951860.982706]        <ffffffff80262222>{system_call+126}
[951860.983407] smbd          S ffff810033e21a48     0 30680   9544 
31724 19761 (NOTLB)
[951860.984346] ffff810033e21a48 ffff810033e21988 ffffffff80267afe 
ffff810033e219d8
[951860.984831]        ffffffff880ba1b4 ffff81010002d340 
0000000000000001 0000000133e21a58
[951860.985648]        0000000000003069 000361ac927e49f2
[951860.986117] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff880ba1b4>{:bonding:bond_alb_xmit+1114}
[951860.986963]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951860.987728]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951860.988496]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951860.989258]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951860.990028]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951860.990802] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951860.991572]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951860.992339]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951860.993108]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951860.993880]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951860.994652]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951860.995705] smbd          S ffff81008ede9a48     0 31724   9544 
8343 30680 (NOTLB)
[951861.002757] ffff81008ede9a48 ffff81008ede99c8 ffffffff802eba75 
0000000000000215
[951861.003238]        ffff8100a43bfc80 ffff81000c005340 
0000000000000000 000000008ede9a58
[951861.004048]        000000000000465b 000361b3d5770d2d
[951861.004516] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951861.004999]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.005765]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.006535]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.007302]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8020de0b>{current_fs_time+79}
[951861.008079]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951861.008875]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff80221867>{generic_file_aio_write+116}
[951861.009649]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80266e89>{__mutex_unlock_slowpath+466}
[951861.010419]        <ffffffff80266eb1>{mutex_unlock+13} 
<ffffffff80221867>{generic_file_aio_write+116}
[951861.011193]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951861.011969]        <ffffffff80262222>{system_call+126}
[951861.012665] afpd          S ffff81012f431b98     0 32105   9910 
17100 27917 (NOTLB)
[951861.013601] ffff81012f431b98 ffff8100c3902648 ffff810098a74508 
ffff81012f431b18
[951861.014082]        0000000000000246 0000000000000000 
0000000000000246 00000000c3902648
[951861.014897]        0000000000000162 000361b42f72b1c5
[951861.015367] Call Trace: <ffffffff80229144>{__kfree_skb+188} 
<ffffffff802665a4>{schedule_timeout+34}
[951861.016201]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951861.016961]        <ffffffff8041bafd>{sk_wait_data+149} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.017731]        <ffffffff80208fb6>{__d_lookup+241} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.018501]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.019277]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951861.020047]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff8020c99c>{do_sync_read+237}
[951861.020819]        <ffffffff80263161>{error_exit+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.021588]        <ffffffff80245dfd>{sys_rt_sigreturn+582} 
<ffffffff8020ae53>{vfs_read+194}
[951861.022358]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951861.023410] smbd          S ffff8100b3959a48     0  8343   9544 
28845 31724 (NOTLB)
[951861.024347] ffff8100b3959a48 ffffffff8055e140 0000000000000297 
000361b24d6ded5b
[951861.024832]        ffffffff806825c0 ffff81000c005340 
0000000000000000 00000000b3959a58
[951861.025650]        0000000000001c53 000361b24d6eec48
[951861.026118] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.026954]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.027725]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.028492]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.029282]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.030057]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.030833]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff802121ff>{poison_obj+58}
[951861.031599]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff80216c08>{sys_select+710}
[951861.032367]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951861.033417] afpd          S ffff81006be25b98     0 17100   9910 
6595 32105 (NOTLB)
[951861.034354] ffff81006be25b98 ffff8100c3902b18 000000000000000b 
ffff81006be25b18
[951861.034836]        ffffffff802327ca 0000000000000008 
0000000000000000 0000000000047580
[951861.035652]        0000000000000645 000361b39a0a4abc
[951861.036119] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951861.036604]        <ffffffff80227d88>{kfree_skbmem+126} 
<ffffffff802665a4>{schedule_timeout+34}
[951861.037386]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951861.038176]        <ffffffff8041bafd>{sk_wait_data+149} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.038952]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80231e6f>{release_sock+191}
[951861.039726]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.040502]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951861.041275]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff8020c99c>{do_sync_read+237}
[951861.042051]        <ffffffff80263161>{error_exit+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.042823]        <ffffffff8020ae53>{vfs_read+194} 
<ffffffff8021122a>{sys_read+71}
[951861.043588]        <ffffffff80262222>{system_call+126}
[951861.044290] retroclient   S ffff810149733ee8     0 14374  11333 
14376   14397 11365 (NOTLB)
[951861.045229] ffff810149733ee8 ffff810100086100 0000000100000010 
000361b5def7aa07
[951861.045708]        ffff810100070000 ffff81010002d340 
0000000000000001 0000000149733ef8
[951861.046517]        0000000000000769 000361b5def7ecbf
[951861.046981] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.047812]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8026664e>{schedule_timeout_interruptible+25}
[951861.048588]        <ffffffff802a22ea>{compat_sys_nanosleep+175} 
<ffffffff80264206>{ia32_sysret+0}
[951861.049639] retropds.23   D ffff810107f29cb8     0 14376  14374 
(NOTLB)
[951861.050576] ffff810107f29cb8 ffff8100015a8f40 0000000000000000 
0000000001ba0002
[951861.051060]        ffff81001a6016d0 ffff810107f29c18 
0000000000000000 0000000007f29c68
[951861.051878]        000000000000055e 00031e4ec0457b33
[951861.052347] Call Trace: <ffffffff802fbb12>{do_get_write_access+876}
[951861.052831]        <ffffffff8029b31e>{wake_bit_function+0} 
<ffffffff8029b31e>{wake_bit_function+0}
[951861.053604]        <ffffffff802eba75>{__ext3_get_inode_loc+350} 
<ffffffff802fbe5f>{journal_get_write_access+34}
[951861.054378] 
<ffffffff802ec40f>{ext3_reserve_inode_write+63} 
<ffffffff802ec4a5>{ext3_mark_inode_dirty+54}
[951861.055154]        <ffffffff802ee60c>{ext3_dirty_inode+106} 
<ffffffff80213f74>{__mark_inode_dirty+45}
[951861.055924]        <ffffffff802d6837>{compat_filldir64+0} 
<ffffffff8020b1e6>{touch_atime+168}
[951861.056693]        <ffffffff802d6837>{compat_filldir64+0} 
<ffffffff80236b49>{vfs_readdir+121}
[951861.057464]        <ffffffff802d6975>{compat_sys_getdents64+121} 
<ffffffff80264206>{ia32_sysret+0}
[951861.058517] retroclient   S ffff810175ec5dc8     0 14397  11333 
14374 (NOTLB)
[951861.059454] ffff810175ec5dc8 ffff810175ec4000 ffff810175ec5d58 
ffffffff8024ae77
[951861.059937]        0000000000000000 0000000000000000 
0000000000000001 0000000100000000
[951861.060746]        00000000000061b9 00031e4ebf8f42ea
[951861.061210] Call Trace: <ffffffff8024ae77>{pipe_wait+158} 
<ffffffff8024ae4f>{pipe_wait+118}
[951861.062037]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff8024ae54>{pipe_wait+123}
[951861.062805]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.063586]        <ffffffff80266cb3>{mutex_lock+38} 
<ffffffff8022fb74>{pipe_readv+779}
[951861.064354]        <ffffffff802c513f>{pipe_read+28} 
<ffffffff8020ae40>{vfs_read+175}
[951861.065118]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80264206>{ia32_sysret+0}
[951861.066165] cron          S ffff810163c55dc8     0 27942   7589 
27943    7771       (NOTLB)
[951861.067103] ffff810163c55dc8 ffff810163c55d18 0000000000000096 
0000000000000100
[951861.067588]        0000000000000001 0000000000000000 
ffffffff80249c05 0000000063c54000
[951861.068404]        0000000000002349 00032d87d3d8f5ac
[951861.068873] Call Trace: <ffffffff80249c05>{try_to_wake_up+982} 
<ffffffff8024ae4f>{pipe_wait+118}
[951861.069704]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff8024ae54>{pipe_wait+123}
[951861.070475]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.071253]        <ffffffff80266cb3>{mutex_lock+38} 
<ffffffff8022fb74>{pipe_readv+779}
[951861.072031]        <ffffffff8022a503>{pipe_writev+1009} 
<ffffffff802c513f>{pipe_read+28}
[951861.072803]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951861.073571]        <ffffffff80262222>{system_call+126}
[951861.074267] bash          S ffff8101421dfe98     0 27943  27942 
27944   28053       (NOTLB)
[951861.081309] ffff8101421dfe98 ffff8101421dfe78 ffffffff802201ec 
0000000000000015
[951861.081792]        ffff81010fb90808 ffff81002ad78638 
0000000000000000 0000000000000206
[951861.082608]        0000000000002d8f 00032d86835558b1
[951861.083076] Call Trace: <ffffffff802201ec>{copy_process+4923} 
<ffffffff8022258c>{__up_read+147}
[951861.083916]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.084686]        <ffffffff80245f39>{sys_rt_sigaction+140} 
<ffffffff80287db7>{default_wake_function+0}
[951861.085460]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.086507] run-crons     S ffff810135b75e98     0 27944  27943 
12803               (NOTLB)
[951861.087444] ffff810135b75e98 ffff810135b75e78 ffffffff802201ec 
0000000000000015
[951861.087926]        ffff8100bcf084c8 ffff81010f34e3c8 
0000000000000000 0000000000000206
[951861.088735]        000000000000c92c 00032de626b5e5af
[951861.089199] Call Trace: <ffffffff802201ec>{copy_process+4923} 
<ffffffff8022258c>{__up_read+147}
[951861.090035]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.090805]        <ffffffff80245f39>{sys_rt_sigaction+140} 
<ffffffff80287db7>{default_wake_function+0}
[951861.091578]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.092622] hotbackup_dai S ffff810152fcfe98     0 27973      1 
28509   27976 32490 (NOTLB)
[951861.093559] ffff810152fcfe98 ffff810152fcfe78 ffffffff802201ec 
0000000000000015
[951861.094040]        00000000aa597db8 0000000000000000 
ffff8100e1340088 0000000000000202
[951861.094855]        0000000000002054 00032d86d6f80b55
[951861.095325] Call Trace: <ffffffff802201ec>{copy_process+4923} 
<ffffffff8022258c>{__up_read+147}
[951861.096167]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.096939]        <ffffffff80245f39>{sys_rt_sigaction+140} 
<ffffffff80287db7>{default_wake_function+0}
[951861.097715]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.098764] hotbackup_dai S ffff810130837e98     0 27976      1 
28058    6218 27973 (NOTLB)
[951861.099700] ffff810130837e98 ffff810130837e78 ffffffff802201ec 
0000000000000015
[951861.100181]        00000000599493f8 0000000000000000 
ffff81013053d7d8 0000000100000206
[951861.100998]        0000000000076ecc 00032d869725b47b
[951861.101465] Call Trace: <ffffffff802201ec>{copy_process+4923} 
<ffffffff8022258c>{__up_read+147}
[951861.102295]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.103059]        <ffffffff80245f39>{sys_rt_sigaction+140} 
<ffffffff80287db7>{default_wake_function+0}
[951861.103826]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.104876] sendmail      S ffff81013ac25dc8     0 28053  27942 
28056         27943 (NOTLB)
[951861.105811] ffff81013ac25dc8 ffff81013ac24000 ffff81013ac25df8 
ffff8101109702d0
[951861.106293]        000000003ac25f48 0000000000000000 
00000000005339e8 000000013ac25d38
[951861.107108]        000000000000219d 00032d87d3d99f86
[951861.107575] Call Trace: <ffffffff8024ae4f>{pipe_wait+118} 
<ffffffff80267ae8>{_spin_unlock+9}
[951861.108401]        <ffffffff8024ae54>{pipe_wait+123} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.109177]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80266cb3>{mutex_lock+38}
[951861.109952]        <ffffffff8022fb74>{pipe_readv+779} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.110726]        <ffffffff802c513f>{pipe_read+28} 
<ffffffff8020ae40>{vfs_read+175}
[951861.111491]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951861.112541] postdrop      S ffff810158301bd8     0 28056  28053 
(NOTLB)
[951861.113478] ffff810158301bd8 0000000000001000 0000000000001000 
0000000000531398
[951861.113959]        ffff81017e4608c0 0000000000000000 
0000000000000001 0000000158301c78
[951861.114775]        0000000000003441 00032d87d3db75d3
[951861.115243] Call Trace: <ffffffff8024d8db>{unix_stream_recvmsg+268}
[951861.115725] 
<ffffffff8023ba87>{debug_mutex_free_waiter+133} 
<ffffffff802665a4>{schedule_timeout+34}
[951861.116506]        <ffffffff8023c873>{prepare_to_wait+97} 
<ffffffff8024da39>{unix_stream_recvmsg+618}
[951861.117274]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.118048]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951861.118816]        <ffffffff80266eb1>{mutex_unlock+13} 
<ffffffff8020c99c>{do_sync_read+237}
[951861.119591]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8020ae53>{vfs_read+194}
[951861.120384]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951861.121435] mv            D ffff810151e37a48     0 28058  27976 
(NOTLB)
[951861.122373] ffff810151e37a48 ffff810151e37a58 ffffffff802fbd0d 
00000000db843658
[951861.122859]        0000000000000046 0000000000000000 
ffff81000cd38800 0000000000000046
[951861.123675]        0000000000006b93 00032d869ef720fd
[951861.124144] Call Trace: <ffffffff802fbd0d>{do_get_write_access+1383}
[951861.124622]        <ffffffff80411eab>{dm_unplug_all+42} 
<ffffffff80411e81>{dm_unplug_all+0}
[951861.125394]        <ffffffff802156f6>{sync_buffer+0} 
<ffffffff80266527>{io_schedule+48}
[951861.126163]        <ffffffff80215734>{sync_buffer+62} 
<ffffffff8026671b>{__wait_on_bit_lock+63}
[951861.126933]        <ffffffff802156f6>{sync_buffer+0} 
<ffffffff802667de>{out_of_line_wait_on_bit_lock+144}
[951861.127708]        <ffffffff8029b31e>{wake_bit_function+0} 
<ffffffff8029b31e>{wake_bit_function+0}
[951861.128481]        <ffffffff80241e52>{__lock_buffer+37} 
<ffffffff802fb82a>{do_get_write_access+132}
[951861.129265]        <ffffffff80219dfb>{__getblk+52} 
<ffffffff802eba75>{__ext3_get_inode_loc+350}
[951861.130035] 
<ffffffff802fbe5f>{journal_get_write_access+34} 
<ffffffff802ec40f>{ext3_reserve_inode_write+63}
[951861.130809]        <ffffffff802ec4a5>{ext3_mark_inode_dirty+54} 
<ffffffff802f2425>{ext3_rename+734}
[951861.131575]        <ffffffff8022b606>{vfs_rename+304} 
<ffffffff8022b68b>{vfs_rename+437}
[951861.132339]        <ffffffff8023867a>{__lookup_hash+104} 
<ffffffff80238510>{sys_renameat+418}
[951861.133120]        <ffffffff802c5f3f>{sys_rename+22} 
<ffffffff80262222>{system_call+126}
[951861.134171] find          D ffff81004ab59cb8     0 28509  27973 
28512       (NOTLB)
[951861.135107] ffff81004ab59cb8 ffff810003aa2c00 0000000000000000 
0000000001450002
[951861.135589]        ffff81010237f1a8 ffff81004ab59c18 
0000000000000000 000000004ab59c68
[951861.136404]        00000000000082bc 00032d9ea2e6c726
[951861.136872] Call Trace: <ffffffff802fbb12>{do_get_write_access+876}
[951861.137355]        <ffffffff8029b31e>{wake_bit_function+0} 
<ffffffff8029b31e>{wake_bit_function+0}
[951861.138127]        <ffffffff802eba75>{__ext3_get_inode_loc+350} 
<ffffffff802fbe5f>{journal_get_write_access+34}
[951861.138900] 
<ffffffff802ec40f>{ext3_reserve_inode_write+63} 
<ffffffff802ec4a5>{ext3_mark_inode_dirty+54}
[951861.139675]        <ffffffff802ee60c>{ext3_dirty_inode+106} 
<ffffffff80213f74>{__mark_inode_dirty+45}
[951861.140444]        <ffffffff80225e60>{filldir+0} 
<ffffffff8020b1e6>{touch_atime+168}
[951861.141213]        <ffffffff80225e60>{filldir+0} 
<ffffffff80236b49>{vfs_readdir+121}
[951861.141979]        <ffffffff8023a361>{sys_getdents+121} 
<ffffffff80262222>{system_call+126}
[951861.143033] sort          S ffff8100d574ddc8     0 28512  27973 
28514 28509 (NOTLB)
[951861.143968] ffff8100d574ddc8 00007fffb2975320 0000000000000003 
0000000000000022
[951861.144450]        0000000003072b80 0000000000000000 
ffffffff80267b3b 00000000d574dd48
[951861.145263]        0000000000029f17 00032d86d6e5e7f3
[951861.145728] Call Trace: <ffffffff80267b3b>{_read_unlock_irq+9} 
<ffffffff8024ae4f>{pipe_wait+118}
[951861.146560]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff8024ae54>{pipe_wait+123}
[951861.147327]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.148107]        <ffffffff80266cb3>{mutex_lock+38} 
<ffffffff8022fb74>{pipe_readv+779}
[951861.148875]        <ffffffff8020dafb>{do_mmap_pgoff+1071} 
<ffffffff802c513f>{pipe_read+28}
[951861.149649]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951861.150420]        <ffffffff80262222>{system_call+126}
[951861.151116] sed           S ffff81003a25bdc8     0 28514  27973 
28512 (NOTLB)
[951861.152053] ffff81003a25bdc8 00000000ffffffff 00000000000000af 
0000000000000022
[951861.152534]        0000000004504a80 0000000000000000 
ffffffff80267b3b 000000003a25bd48
[951861.153352]        00000000000149d8 00032d86d6f769ad
[951861.153821] Call Trace: <ffffffff80267b3b>{_read_unlock_irq+9} 
<ffffffff8024ae4f>{pipe_wait+118}
[951861.160772]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff8024ae54>{pipe_wait+123}
[951861.161541]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.162321]        <ffffffff80266cb3>{mutex_lock+38} 
<ffffffff8022fb74>{pipe_readv+779}
[951861.163085]        <ffffffff80269a07>{do_page_fault+1189} 
<ffffffff802c513f>{pipe_read+28}
[951861.163849]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951861.164628]        <ffffffff80262222>{system_call+126}
[951861.165324] slocate       S ffff81007375fe98     0 12803  27944 
12804               (NOTLB)
[951861.166259] ffff81007375fe98 ffff81007375fe78 ffffffff802201ec 
0000000000000016
[951861.166742]        ffff8100ca77d738 ffff81008b8fe000 
0000000000000000 0000000000000212
[951861.167559]        000000000001c425 00032de62789ab86
[951861.168027] Call Trace: <ffffffff802201ec>{copy_process+4923} 
<ffffffff8022258c>{__up_read+147}
[951861.168864]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.169634]        <ffffffff80245f39>{sys_rt_sigaction+140} 
<ffffffff80287db7>{default_wake_function+0}
[951861.170409]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.171456] updatedb      D ffff81006216be68     0 12804  12803 
(NOTLB)
[951861.172393] ffff81006216be68 ffff81006216bdc8 ffffffff8020f160 
ffff81006216bea8
[951861.172878]        ffff81009cda72f0 0000000000018801 
0000000000000001 000000016216bdd8
[951861.173691]        0000000000100c62 00032de991d57cc4
[951861.174155] Call Trace: <ffffffff8020f160>{generic_permission+109}
[951861.174628]        <ffffffff80236b18>{vfs_readdir+72} 
<ffffffff80236b18>{vfs_readdir+72}
[951861.175389]        <ffffffff80266a2c>{__mutex_lock_slowpath+414} 
<ffffffff80225e60>{filldir+0}
[951861.176191]        <ffffffff80266cb3>{mutex_lock+38} 
<ffffffff80236b18>{vfs_readdir+72}
[951861.176958]        <ffffffff8023a361>{sys_getdents+121} 
<ffffffff8023d548>{sys_fchdir+116}
[951861.177734]        <ffffffff80262222>{system_call+126}
[951861.178430] smbd          D ffff81013a7535c8     0 28845   9544 
2145  8343 (NOTLB)
[951861.179365] ffff81013a7535c8 ffff8100309be7a0 ffffffff80361fc6 
ffff81000cd235e8
[951861.179844]        0000000079926aa8 0000000000000000 
0000000000000001 000000013a753558
[951861.180660]        00000000000000b4 00035d4558f4f985
[951861.181129] Call Trace: <ffffffff80361fc6>{cfq_add_crq_rb+209} 
<ffffffff880dbc8d>{:drbd:lc_find+55}
[951861.181972]        <ffffffff880d99f4>{:drbd:drbd_al_begin_io+410} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.182763]        <ffffffff802237b5>{mempool_alloc+73} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.183557]        <ffffffff802c0d6d>{__bio_clone+126} 
<ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.184343]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.185108]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.185879]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.186654]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.187432] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.188199]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.188966]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.189729]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff8021ea22>{__pollwait+0}
[951861.190506]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951861.191286]        <ffffffff80217cb4>{cache_grow+290} 
<ffffffff80261526>{cache_alloc_refill+505}
[951861.192059]        <ffffffff80211ce4>{getname+37} 
<ffffffff8020a36d>{kmem_cache_alloc+166}
[951861.192830]        <ffffffff80211ce4>{getname+37} 
<ffffffff80223eae>{__user_walk_fd+32}
[951861.193601]        <ffffffff80228d8f>{vfs_stat_fd+36} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951861.194376]        <ffffffff80223b57>{sys_newstat+34} 
<ffffffff80290fa4>{__capable+14}
[951861.195143]        <ffffffff80290fd0>{capable+22} 
<ffffffff80296213>{sys_setresuid+520}
[951861.195910]        <ffffffff80262222>{system_call+126}
[951861.196607] smbd          D ffff81011c1653c8     0  2145   9544 
2885 28845 (NOTLB)
[951861.197545] ffff81011c1653c8 ffff8101104e10c0 0000000000000046 
0000000000000004
[951861.198027]        0000000000000002 0000000000000000 
0000000000000001 0000000137f063b8
[951861.198841]        00000000000000b5 00035d4558f50ddd
[951861.199309] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.200168]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.200954]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.201731]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.202163]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.202923]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.203686]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.204462]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.205239] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.206010]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.206785]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.207558]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff8020aa98>{__find_get_block+164}
[951861.208332]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff802ff324>{find_revoke_record+149}
[951861.209101]        <ffffffff802fb494>{__journal_file_buffer+347} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.209882]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff8021612b>{alloc_pages_current+126}
[951861.210653]        <ffffffff802a9cdd>{page_cache_alloc+23} 
<ffffffff8020f8a4>{generic_file_buffered_write+481}
[951861.211427]        <ffffffff8020de0b>{current_fs_time+79} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951861.212196]        <ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951861.212624]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff8022185c>{generic_file_aio_write+105}
[951861.213407]        <ffffffff802e964c>{ext3_file_write+28} 
<ffffffff80218600>{do_sync_write+237}
[951861.214186]        <ffffffff80241d9b>{locks_free_lock+92} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.214958]        <ffffffff802943a2>{kill_proc_info+75} 
<ffffffff80216e7a>{vfs_write+178}
[951861.215733]        <ffffffff802461f2>{sys_pwrite64+88} 
<ffffffff80262222>{system_call+126}
[951861.216774] smbd          S ffff81016c67da48     0  2885   9544 
3571  2145 (NOTLB)
[951861.217703] ffff81016c67da48 ffff81016c67d988 ffffffff80267afe 
ffff81016c67d9d8
[951861.218185]        ffffffff880ba1b4 ffff81000c005340 
0000000000000000 000000006c67da58
[951861.219003]        000000000000125b 000361aede2b9619
[951861.219472] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff880ba1b4>{:bonding:bond_alb_xmit+1114}
[951861.220312]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.221081]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.221853]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.222623]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951861.223395]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951861.224165] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951861.224935]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951861.225713]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951861.226484]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951861.227257]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951861.228026]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951861.229078] smbd          S ffff810017c55a48     0  3571   9544 
5313  2885 (NOTLB)
[951861.230014] ffff810017c55a48 ffff810017c55988 ffffffff80267afe 
ffff810017c559d8
[951861.230494]        ffffffff880ba1b4 ffff81000c005340 
0000000000000000 0000000017c55a58
[951861.231305]        0000000000001a1f 000361adefe8bc7f
[951861.231769] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff880ba1b4>{:bonding:bond_alb_xmit+1114}
[951861.238719]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.239492]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.240265]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.241034]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951861.241803]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951861.242574] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951861.243345]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951861.244115]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951861.244886]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951861.245651]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951861.246420]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951861.247483] smbd          S ffff81010f24ba48     0  5313   9544 
5417  3571 (NOTLB)
[951861.248419] ffff81010f24ba48 ffffffff8055e140 0000000000000297 
000361afb1c57649
[951861.248901]        ffffffff806825c0 ffff81000c005340 
0000000000000000 000000000f24ba58
[951861.249718]        00000000000024f1 000361afb1c6c2c3
[951861.250187] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.251019]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.251792]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.252560]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.253340]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.254120]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.254897]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff802121ff>{poison_obj+58}
[951861.255666]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff80216c08>{sys_select+710}
[951861.256444]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951861.257504] smbd          D ffff810145f9f348     0  5417   9544 
5468  5313 (NOTLB)
[951861.258441] ffff810145f9f348 ffff8101004ca0c0 ffff81014c8f1eb0 
ffff81014c8f1eb0
[951861.258929]        00000000352802d8 0000000000000000 
0000000000000001 0000000100000001
[951861.259740]        00000000000000c1 00035d4558f50055
[951861.260205] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.261059]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.261852]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.262654]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.263086]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.263852]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.264625]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.265402]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.266171] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.266942]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.267718]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.268491]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.269274]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff8021612b>{alloc_pages_current+126}
[951861.270048]        <ffffffff802a9cfc>{page_cache_alloc_cold+29} 
<ffffffff802124d1>{__do_page_cache_readahead+182}
[951861.270827]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80233c98>{blockable_page_cache_readahead+93}
[951861.271604]        <ffffffff8022fced>{make_ahead_window+137} 
<ffffffff802143e9>{page_cache_readahead+393}
[951861.272376] 
<ffffffff8020b957>{do_generic_mapping_read+316} 
<ffffffff8020cbf5>{file_read_actor+0}
[951861.273157] 
<ffffffff8020bdcb>{__generic_file_aio_read+371} 
<ffffffff802171f3>{generic_file_aio_read+54}
[951861.273931]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff80241d9b>{locks_free_lock+92}
[951861.274697]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951861.275467]        <ffffffff80265b94>{thread_return+101} 
<ffffffff8020ae40>{vfs_read+175}
[951861.276238]        <ffffffff80213834>{sys_pread64+88} 
<ffffffff80262222>{system_call+126}
[951861.277290] mon           D ffff81013a4355c8     0  5444   7184 
9613       (NOTLB)
[951861.278225] ffff81013a4355c8 ffff810112e728a0 0000000000000000 
0000000000000000
[951861.278704]        0000000000000000 0000000000000000 
0000000000000000 0000000100000000
[951861.279521]        00000000000000cb 00035d4558f5077d
[951861.279988] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.280846]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.281622]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.282399]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.282831]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.283598]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.284369]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.285152]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.285918] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.286689]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.287464]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.288231]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.289009]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff80221b31>{alloc_page_vma+122}
[951861.289779]        <ffffffff80210a83>{do_wp_page+315} 
<ffffffff80208e71>{__handle_mm_fault+2268}
[951861.290556]        <ffffffff802699bf>{do_page_fault+1117} 
<ffffffff80262222>{system_call+126}
[951861.291330]        <ffffffff80263161>{error_exit+0}
[951861.292024] smbd          D ffff810069cc7348     0  5468   9544 
6390  5417 (NOTLB)
[951861.292959] ffff810069cc7348 ffff81012eeb8100 ffff810023959c30 
ffff810023959c30
[951861.293442]        0000000026ec0310 0000000000000000 
0000000000000000 0000000000000001
[951861.294258]        000000000000010b 00035d4558d474fb
[951861.294725] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.295583]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.296361]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.297139]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.297572]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.298339]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.299107]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.299891]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.300661] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.301432]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.302203]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.302969]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.303748]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff8021612b>{alloc_pages_current+126}
[951861.304521]        <ffffffff802a9cfc>{page_cache_alloc_cold+29} 
<ffffffff802124d1>{__do_page_cache_readahead+182}
[951861.305297]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80233c98>{blockable_page_cache_readahead+93}
[951861.306073]        <ffffffff8022fced>{make_ahead_window+137} 
<ffffffff802143e9>{page_cache_readahead+393}
[951861.306845] 
<ffffffff8020b957>{do_generic_mapping_read+316} 
<ffffffff8020cbf5>{file_read_actor+0}
[951861.307630] 
<ffffffff8020bdcb>{__generic_file_aio_read+371} 
<ffffffff802171f3>{generic_file_aio_read+54}
[951861.308430]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff80241d9b>{locks_free_lock+92}
[951861.309204]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951861.316091]        <ffffffff80265b94>{thread_return+101} 
<ffffffff8020ae40>{vfs_read+175}
[951861.316854]        <ffffffff80213834>{sys_pread64+88} 
<ffffffff80262222>{system_call+126}
[951861.317895] bash          S ffff810019959e98     0  6218      1 
6237    6332 27976 (NOTLB)
[951861.318828] ffff810019959e98 ffff810019959dd8 ffffffff80287dc4 
ffff810019959df8
[951861.319309]        000000008029b2f6 0000000000000000 
ffff81017d56f978 0000000000000202
[951861.320125]        000000000000dcf2 00034e67c0e7467b
[951861.320591] Call Trace: <ffffffff80287dc4>{default_wake_function+13}
[951861.321070]        <ffffffff8022258c>{__up_read+147} 
<ffffffff80228826>{do_wait+2714}
[951861.321839]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951861.322610]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8025845f>{sys_wait4+40}
[951861.323382]        <ffffffff80262222>{system_call+126}
[951861.324080] cp            D ffff81002849b3c8     0  6237   6218 
(NOTLB)
[951861.325015] ffff81002849b3c8 ffff8101463db820 ffff81006dcc2c98 
ffff81000cd38800
[951861.325501]        000000006dcc2c98 0000000000000000 
0000000000000000 0000000000000001
[951861.326315]        000000000000010c 00035d4558d46b92
[951861.326783] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.327640]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.328417]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.329192]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.329624]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.330392]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.331156]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.331928]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.332700] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.333469]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.334242]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.335014]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff80267ae8>{_spin_unlock+9}
[951861.335782]        <ffffffff802ff324>{find_revoke_record+149} 
<ffffffff8020cb89>{bit_waitqueue+58}
[951861.336558]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951861.337334]        <ffffffff8021612b>{alloc_pages_current+126} 
<ffffffff802a9cdd>{page_cache_alloc+23}
[951861.338107]        <ffffffff8020f8a4>{generic_file_buffered_write+481}
[951861.338530]        <ffffffff8020de0b>{current_fs_time+79} 
<ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951861.339312]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff8022185c>{generic_file_aio_write+105}
[951861.340095]        <ffffffff802e964c>{ext3_file_write+28} 
<ffffffff80218600>{do_sync_write+237}
[951861.340866]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951861.341639]        <ffffffff80265be2>{thread_return+179} 
<ffffffff80216e7a>{vfs_write+178}
[951861.342411]        <ffffffff802176f7>{sys_write+71} 
<ffffffff80262222>{system_call+126}
[951861.343459] bash          S ffff81005afffe98     0  6332      1 
6340   28411  6218 (NOTLB)
[951861.344398] ffff81005afffe98 ffff81005afffdd8 ffffffff80287dc4 
ffff81005afffdf8
[951861.344877]        ffffffff8029b2f6 ffff81008b8fe000 
0000000000000000 0000000000000202
[951861.345687]        000000000000a7fa 00034ed75a349b0c
[951861.346151] Call Trace: <ffffffff80287dc4>{default_wake_function+13}
[951861.346625] 
<ffffffff8029b2f6>{autoremove_wake_function+15} 
<ffffffff8022258c>{__up_read+147}
[951861.347402]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.348175]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80287db7>{default_wake_function+0}
[951861.348948]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.349995] rm            D ffff81000fad9e18     0  6340   6332 
(NOTLB)
[951861.350932] ffff81000fad9e18 ffff81000fad9d58 ffffffff802fa0ca 
ffff81000fad9d68
[951861.351415]        ffffffff8020d52c ffff81000fad9d78 
0000000000000000 000000000fad9de8
[951861.352231]        00000000001080b4 00034ed76feaa558
[951861.352700] Call Trace: <ffffffff802fa0ca>{ext3_permission+16} 
<ffffffff8020d52c>{permission+120}
[951861.353529]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff8024d384>{vfs_unlink+136}
[951861.354316]        <ffffffff8024d384>{vfs_unlink+136} 
<ffffffff80266a2c>{__mutex_lock_slowpath+414}
[951861.355104]        <ffffffff80266cb3>{mutex_lock+38} 
<ffffffff8024d384>{vfs_unlink+136}
[951861.355872]        <ffffffff8023e370>{do_unlinkat+187} 
<ffffffff8023a39a>{sys_getdents+178}
[951861.356651]        <ffffffff802c5c84>{sys_unlink+17} 
<ffffffff80262222>{system_call+126}
[951861.357698] smbd          S ffff81006a3fda48     0  6390   9544 
7136  5468 (NOTLB)
[951861.358636] ffff81006a3fda48 ffffffff8055e140 ffffffff802eba75 
000361ae5f4d0798
[951861.359114]        ffffffff806825c0 ffff81000c005340 
0000000000000000 000000006a3fda58
[951861.359924]        0000000000000a9d 000361ae5f4d671f
[951861.360389] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951861.360867]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.361639]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.362410]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.363178]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8020de0b>{current_fs_time+79}
[951861.363956]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951861.364747]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff80221867>{generic_file_aio_write+116}
[951861.365519]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80266e89>{__mutex_unlock_slowpath+466}
[951861.366287]        <ffffffff80266eb1>{mutex_unlock+13} 
<ffffffff80221867>{generic_file_aio_write+116}
[951861.367075]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951861.367849]        <ffffffff80262222>{system_call+126}
[951861.368544] ls            D ffff81005d165e68     0  6499  28411 
(NOTLB)
[951861.369481] ffff81005d165e68 ffff81005d165da8 ffffffff80267ae8 
ffff81005d165e58
[951861.369964]        ffffffff80208aee 0000000000018801 
0000000000000000 000000005d165dd8
[951861.370779]        00000000000190e7 00034f9b31c625d3
[951861.371247] Call Trace: <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff80208aee>{__handle_mm_fault+1369}
[951861.372076]        <ffffffff80236b18>{vfs_readdir+72} 
<ffffffff80236b18>{vfs_readdir+72}
[951861.372843]        <ffffffff80266a2c>{__mutex_lock_slowpath+414} 
<ffffffff80225e60>{filldir+0}
[951861.373609]        <ffffffff80266cb3>{mutex_lock+38} 
<ffffffff80236b18>{vfs_readdir+72}
[951861.374368]        <ffffffff8023a361>{sys_getdents+121} 
<ffffffff80263161>{error_exit+0}
[951861.375133]        <ffffffff80262222>{system_call+126}
[951861.375837] afpd          S ffff8100348cdb98     0  6595   9910 
7084 17100 (NOTLB)
[951861.376774] ffff8100348cdb98 ffff8100f7f7b500 0000000000000020 
ffff8100348cdb08
[951861.377256]        ffff8100c3902b78 ffff8100af655108 
0000000000000000 00000000c3902b20
[951861.378073]        000000000000057d 000361b290503eb3
[951861.378541] Call Trace: <ffffffff8023c3a0>{tcp_send_ack+227} 
<ffffffff802665a4>{schedule_timeout+34}
[951861.379374]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951861.380137]        <ffffffff8041bafd>{sk_wait_data+149} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.380911]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80231e6f>{release_sock+191}
[951861.381683]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.382459]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951861.383229]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff8020c99c>{do_sync_read+237}
[951861.383997]        <ffffffff80263161>{error_exit+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.384771]        <ffffffff8020ae53>{vfs_read+194} 
<ffffffff8021122a>{sys_read+71}
[951861.385538]        <ffffffff80262222>{system_call+126}
[951861.386239] cnid_dbd      D ffff8100db2abda8     0  6947   9901 
8222 27918 (NOTLB)
[951861.387176] ffff8100db2abda8 ffff81009719a838 0000000000000000 
ffff810161c15140
[951861.387654]        ffff81009719a838 ffff8100db2abd08 
0000000000000000 00000000db2abde8
[951861.394582]        00000000000000bc 000351fb3ef4d8df
[951861.395051] Call Trace: <ffffffff80300010>{log_wait_commit+212}
[951861.395534]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.396314]        <ffffffff80292650>{process_timeout+0} 
<ffffffff802fb11f>{journal_stop+510}
[951861.397096]        <ffffffff802fb179>{journal_force_commit+35} 
<ffffffff802f3c8e>{ext3_force_commit+38}
[951861.397868]        <ffffffff802e976a>{ext3_sync_file+155} 
<ffffffff80266cb3>{mutex_lock+38}
[951861.398637]        <ffffffff80253856>{do_fsync+109} 
<ffffffff802bf71e>{__do_fsync+44}
[951861.399403]        <ffffffff802bf73f>{sys_fsync+11} 
<ffffffff80262222>{system_call+126}
[951861.400452] afpd          S ffff8100c6173b98     0  7084   9910 
7213  6595 (NOTLB)
[951861.401389] ffff8100c6173b98 ffff8100598f8e00 000000000000000e 
ffff8100c6173b18
[951861.401868]        00000000802327ca 0000000000000000 
ffff8100f7d0ab10 0000000000047580
[951861.402677]        0000000000000156 000361b48c3b947e
[951861.403142] Call Trace: <ffffffff802665a4>{schedule_timeout+34}
[951861.403621]        <ffffffff80267b1a>{_spin_unlock_bh+14} 
<ffffffff80231e6f>{release_sock+191}
[951861.404386]        <ffffffff8041bafd>{sk_wait_data+149} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.405163]        <ffffffff80208fb6>{__d_lookup+241} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.405935]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.406710]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951861.407478]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff8020c99c>{do_sync_read+237}
[951861.408260]        <ffffffff80263161>{error_exit+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.409034]        <ffffffff80245dfd>{sys_rt_sigreturn+582} 
<ffffffff8020ae53>{vfs_read+194}
[951861.409804]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951861.410857] smbd          D ffff81014a8ff348     0  7136   9544 
7149  6390 (NOTLB)
[951861.411793] ffff81014a8ff348 ffff8100ee1c5100 0000000000011200 
0000000000000010
[951861.412274]        0000000000000001 0000000000000000 
0000000000000000 0000000000000000
[951861.413090]        0000000000000157 00035d4558d46222
[951861.413559] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.414415]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.415191]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.415968]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.416397]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.417157]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.417924]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.418707]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.419474] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.420245]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.421031]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.421799]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff8807dff4>{:ip_conntrack:tcp_packet+3069}
[951861.422593]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951861.423369]        <ffffffff8021612b>{alloc_pages_current+126} 
<ffffffff802a9cfc>{page_cache_alloc_cold+29}
[951861.424141] 
<ffffffff802124d1>{__do_page_cache_readahead+182} 
<ffffffff8021ea22>{__pollwait+0}
[951861.424916]        <ffffffff80233c98>{blockable_page_cache_readahead+93}
[951861.425337]        <ffffffff8022fced>{make_ahead_window+137} 
<ffffffff802143e9>{page_cache_readahead+393}
[951861.426105] 
<ffffffff8020b957>{do_generic_mapping_read+316} 
<ffffffff8020cbf5>{file_read_actor+0}
[951861.426888] 
<ffffffff8020bdcb>{__generic_file_aio_read+371} 
<ffffffff802171f3>{generic_file_aio_read+54}
[951861.427670]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff80241d9b>{locks_free_lock+92}
[951861.428444]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8020ae40>{vfs_read+175}
[951861.429221]        <ffffffff80213834>{sys_pread64+88} 
<ffffffff80262222>{system_call+126}
[951861.430270] smbd          S ffff81011d311a48     0  7149   9544 
7754  7136 (NOTLB)
[951861.431202] ffff81011d311a48 ffffffff8055e140 ffffffff802eba75 
000361aa68d762fd
[951861.431680]        ffffffff806825c0 ffff81000c005340 
0000000000000000 000000001d311a58
[951861.432498]        0000000000002276 000361aa68d89925
[951861.432968] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951861.433446]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.434213]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.434984]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.435754]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.436531]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.437308]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.438088]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff802121ff>{poison_obj+58}
[951861.438862]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff80216c08>{sys_select+710}
[951861.439640]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951861.440695] afpd          D ffff8100311e7348     0  7213   9910 
7757  7084 (NOTLB)
[951861.441633] ffff8100311e7348 ffff8101003335c0 0000000000011200 
0000000000000010
[951861.442113]        0000000000000001 0000000000000000 
ffff81005c5557c0 0000000000000000
[951861.442928]        000000000001fb63 00035e56680377bc
[951861.443397] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.444254]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.445028]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.445799]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.446228]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.446996]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.447767]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.448541]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.449305] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.450078]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.450866]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.451635]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.452421]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff8021612b>{alloc_pages_current+126}
[951861.453196]        <ffffffff802a9cfc>{page_cache_alloc_cold+29} 
<ffffffff802124d1>{__do_page_cache_readahead+182}
[951861.453972]        <ffffffff8021c2b2>{tcp_rcv_established+1886} 
<ffffffff8023d129>{tcp_v4_do_rcv+46}
[951861.454748]        <ffffffff80233c98>{blockable_page_cache_readahead+93}
[951861.455175]        <ffffffff8022fced>{make_ahead_window+137} 
<ffffffff802143e9>{page_cache_readahead+393}
[951861.455944] 
<ffffffff8020b957>{do_generic_mapping_read+316} 
<ffffffff8020cbf5>{file_read_actor+0}
[951861.456723] 
<ffffffff8020bdcb>{__generic_file_aio_read+371} 
<ffffffff802171f3>{generic_file_aio_read+54}
[951861.457503]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff8041a413>{sys_sendto+295}
[951861.458278]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8020ae40>{vfs_read+175}
[951861.459049]        <ffffffff80213834>{sys_pread64+88} 
<ffffffff80262222>{system_call+126}
[951861.460099] smbd          D ffff810101577348     0  7754   9544 
7758  7149 (NOTLB)
[951861.461036] ffff810101577348 ffff81007eb63140 0000000000011200 
0000000000000010
[951861.461518]        0000000000000001 0000000000000000 
0000000000000000 0000000000000000
[951861.462335]        0000000000000123 00035d4558d44bfb
[951861.462803] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.463660]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.464436]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.465214]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.465646]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.472530]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.473297]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.474066]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.474829] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.475599]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.476371]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.477139]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.477917]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951861.478697]        <ffffffff8021612b>{alloc_pages_current+126} 
<ffffffff802a9cfc>{page_cache_alloc_cold+29}
[951861.479469] 
<ffffffff802124d1>{__do_page_cache_readahead+182} 
<ffffffff8021ea22>{__pollwait+0}
[951861.480256]        <ffffffff80233c98>{blockable_page_cache_readahead+93}
[951861.480677]        <ffffffff8022fced>{make_ahead_window+137} 
<ffffffff802143e9>{page_cache_readahead+393}
[951861.481449] 
<ffffffff8020b957>{do_generic_mapping_read+316} 
<ffffffff8020cbf5>{file_read_actor+0}
[951861.482229] 
<ffffffff8020bdcb>{__generic_file_aio_read+371} 
<ffffffff802171f3>{generic_file_aio_read+54}
[951861.483011]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff80241d9b>{locks_free_lock+92}
[951861.483785]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951861.484556]        <ffffffff80265b94>{thread_return+101} 
<ffffffff8020ae40>{vfs_read+175}
[951861.485328]        <ffffffff80213834>{sys_pread64+88} 
<ffffffff80262222>{system_call+126}
[951861.486382] afpd          D ffff81010cae95c8     0  7757   9910 
7778  7213 (NOTLB)
[951861.487320] ffff81010cae95c8 ffff8100bae897e0 6b6b6b6b6b6b6b6b 
6b6b6b6b6b6b6b6b
[951861.487798]        000000006b6b6b6b 0000000000000000 
0000000000000001 000000016b6b6b6b
[951861.488606]        0000000000000121 00035d4558f4f32a
[951861.489071] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.489928]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.490707]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.491486]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.491918]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.492683]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.493455]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.494237]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.495004] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.495775]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.496551]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.497322]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.498107]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff80221b31>{alloc_page_vma+122}
[951861.498880]        <ffffffff80210a83>{do_wp_page+315} 
<ffffffff80208e71>{__handle_mm_fault+2268}
[951861.499661]        <ffffffff802699bf>{do_page_fault+1117} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951861.500430]        <ffffffff8022949a>{do_sigaction+438} 
<ffffffff8020ae53>{vfs_read+194}
[951861.501200]        <ffffffff80263161>{error_exit+0}
[951861.501895] smbd          D ffff810144c755c8     0  7758   9544 
7764  7754 (NOTLB)
[951861.502824] ffff810144c755c8 ffff8101150990c0 ffffffff802f2ad1 
000000005a2cf071
[951861.503306]        000000006b6b6b6b 0000000000000000 
0000000000000000 000000006b6b6b6b
[951861.504122]        0000000000000127 00035d4558d43952
[951861.504590] Call Trace: <ffffffff802f2ad1>{ext3_destroy_inode+23}
[951861.505070]        <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.505866]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.506642]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.507420]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.507852]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.508620]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.509391]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.510169]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.510935] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.511708]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.512482]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.513253]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.514037]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff80221b31>{alloc_page_vma+122}
[951861.514811]        <ffffffff80210a83>{do_wp_page+315} 
<ffffffff80208e71>{__handle_mm_fault+2268}
[951861.515597]        <ffffffff802170db>{prio_tree_insert+378} 
<ffffffff8020d52c>{permission+120}
[951861.516364]        <ffffffff802699bf>{do_page_fault+1117} 
<ffffffff8023126c>{__up_write+267}
[951861.517131]        <ffffffff80263161>{error_exit+0}
[951861.517822] smbd          S ffff81015a257a48     0  7764   9544 
8002  7758 (NOTLB)
[951861.518759] ffff81015a257a48 ffffffff8055e140 ffffffff802eba75 
000361ac89eabbd5
[951861.519243]        ffffffff806825c0 ffff81000c005340 
0000000000000000 000000005a257a58
[951861.520060]        0000000000002036 000361ac89ebddbd
[951861.520528] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951861.521009]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.521780]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.522550]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.523320]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.524098]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.524876]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.525653]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff802121ff>{poison_obj+58}
[951861.526421]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff80216c08>{sys_select+710}
[951861.527195]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951861.528249] cron          S ffff8101539d9dc8     0  7771   7589 
7772         27942 (NOTLB)
[951861.529187] ffff8101539d9dc8 ffff810174303bb0 0000000000000000 
ffff810139e10100
[951861.529668]        0000000000000000 ffff8101539d9d28 
0000000000000000 00000000539d9e08
[951861.530480]        0000000000000d62 000358054ae648b4
[951861.530946] Call Trace: <ffffffff8024ae4f>{pipe_wait+118} 
<ffffffff80267ae8>{_spin_unlock+9}
[951861.531767]        <ffffffff8024ae54>{pipe_wait+123} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.532542]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80266cb3>{mutex_lock+38}
[951861.533318]        <ffffffff8022fb74>{pipe_readv+779} 
<ffffffff8020dafb>{do_mmap_pgoff+1071}
[951861.534099]        <ffffffff802c513f>{pipe_read+28} 
<ffffffff8020ae40>{vfs_read+175}
[951861.534864]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951861.535919] bash          S ffff81011f827e98     0  7772   7771 
7773               (NOTLB)
[951861.536856] ffff81011f827e98 ffff81011f827e78 ffffffff802201ec 
0000000000000015
[951861.537339]        0000000032f91c18 0000000000000000 
ffff810096e15228 0000000000000202
[951861.538156]        0000000000032307 000358054ae5eb06
[951861.538625] Call Trace: <ffffffff802201ec>{copy_process+4923} 
<ffffffff8022258c>{__up_read+147}
[951861.539465]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.540236]        <ffffffff80245f39>{sys_rt_sigaction+140} 
<ffffffff80287db7>{default_wake_function+0}
[951861.541010]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.542056] run-crons     D ffff810174a35638     0  7773   7772 
(NOTLB)
[951861.542994] ffff810174a35638 ffff810174a35608 0000000000000246 
00002b869ea4d7a0
[951861.543475]        000000009feb7b44 0000000000000000 
ffff810174a34000 0000000000000000
[951861.550404]        000000000000080e 00035d4558d41a59
[951861.550871] Call Trace: <ffffffff80267adb>{_spin_unlock_irqrestore+17}
[951861.551353]        <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.552151]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.552927]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.553702]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.554135]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.554902]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.555673]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.556448]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.557227] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.557997]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.558768]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.559533]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff8020a24a>{get_page_from_freelist+924}
[951861.560311]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951861.561085]        <ffffffff80221b31>{alloc_page_vma+122} 
<ffffffff80208980>{__handle_mm_fault+1003}
[951861.561860]        <ffffffff80207e85>{unmap_vmas+1457} 
<ffffffff802699bf>{do_page_fault+1117}
[951861.562633]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff8022949a>{do_sigaction+438}
[951861.563405]        <ffffffff80263161>{error_exit+0}
[951861.564100] afpd          D ffff8100953455c8     0  7778   9910 
8220  7757 (NOTLB)
[951861.565037] ffff8100953455c8 ffff8100f7f62760 0003040001fa81b0 
42b40186445fa28c
[951861.565520]        000000003d050226 0000000000000000 
0000000000000001 0000000102545103
[951861.566336]        000000000000014b 00035d4558f4e8fb
[951861.566805] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.567662]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.568438]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.569216]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.569650]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.570418]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.571189]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.571966]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.572734] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.573500]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.574268]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.575038]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.575823]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff80221b31>{alloc_page_vma+122}
[951861.576596]        <ffffffff80210a83>{do_wp_page+315} 
<ffffffff80208e71>{__handle_mm_fault+2268}
[951861.577394]        <ffffffff802699bf>{do_page_fault+1117} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951861.578164]        <ffffffff8022949a>{do_sigaction+438} 
<ffffffff8020ae53>{vfs_read+194}
[951861.578944]        <ffffffff80263161>{error_exit+0}
[951861.579654] smbd          S ffff81013696ba48     0  8002   9544 
8088  7764 (NOTLB)
[951861.580591] ffff81013696ba48 ffffffff8055e140 ffffffff802eba75 
000361b3c1b309fe
[951861.581073]        ffffffff806825c0 ffff81000c005340 
0000000000000000 000000003696ba58
[951861.581891]        0000000000000892 000361b3c1b35726
[951861.582359] Call Trace: <ffffffff802eba75>{__ext3_get_inode_loc+350}
[951861.582838]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.583605]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.584375]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.585144]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.585923]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.586700]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.587473]        <ffffffff8020e58a>{link_path_walk+216} 
<ffffffff802121ff>{poison_obj+58}
[951861.588235]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff80216c08>{sys_select+710}
[951861.589006]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951861.590059] smbd          S ffff810101ae1a48     0  8088   9544 
9451  8002 (NOTLB)
[951861.590995] ffff810101ae1a48 ffff810101ae1988 ffffffff80267afe 
ffff810101ae19d8
[951861.591478]        ffffffff880ba1b4 ffff81000c005340 
0000000000000000 0000000001ae1a58
[951861.592294]        0000000000001426 000361b31a5efe85
[951861.592762] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff880ba1b4>{:bonding:bond_alb_xmit+1114}
[951861.593606]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.594376]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.595149]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.595920]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff8024b433>{mod_timer+43}
[951861.596693]        <ffffffff80258fae>{sk_reset_timer+21} 
<ffffffff8023c1af>{update_send_head+137}
[951861.597465] 
<ffffffff80234b7b>{__tcp_push_pending_frames+2050} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951861.598235]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951861.599005]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802480ed>{inet_sendmsg+70}
[951861.599776]        <ffffffff80239408>{do_sock_write+163} 
<ffffffff8024a41a>{sock_aio_write+87}
[951861.600548]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff80216c08>{sys_select+710}
[951861.601321]        <ffffffff8022b92a>{sys_newfstat+41} 
<ffffffff80262222>{system_call+126}
[951861.602363] afpd          D ffff810070d87368     0  8220   9910 
9575  7778 (NOTLB)
[951861.603296] ffff810070d87368 ffff810070d872a8 ffffffff8022eeea 
ffff810070d87348
[951861.603778]        ffffffff880d9138 ffff8100f5f94b40 
0000000000000000 0000000000000001
[951861.604594]        00000000000001db 00035e339408f3c1
[951861.605062] Call Trace: <ffffffff8022eeea>{bio_put+49} 
<ffffffff880d9138>{:drbd:_drbd_md_sync_page_io+217}
[951861.605905]        <ffffffff80265ccd>{wait_for_completion+165} 
<ffffffff80287db7>{default_wake_function+0}
[951861.606681]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff880d9b1c>{:drbd:drbd_al_begin_io+706}
[951861.607471]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.608242]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022ed34>{blk_recount_segments+122}
[951861.609011] 
<ffffffff880d9c26>{:drbd:w_al_write_transaction+0} 
<ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.609819]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.610587]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.611359]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.612131]        <ffffffff802fbd0d>{do_get_write_access+1383} 
<ffffffff80234d09>{submit_bio+203}
[951861.612901]        <ffffffff8021abd8>{submit_bh+267} 
<ffffffff802178f8>{ll_rw_block+177}
[951861.613668]        <ffffffff802fe630>{__flush_batch+52} 
<ffffffff802fef09>{log_do_checkpoint+565}
[951861.614438]        <ffffffff802eba75>{__ext3_get_inode_loc+350} 
<ffffffff802ec398>{ext3_mark_iloc_dirty+824}
[951861.615213]        <ffffffff80267b3b>{_read_unlock_irq+9} 
<ffffffff8028696c>{__activate_task+31}
[951861.615982]        <ffffffff80249c05>{try_to_wake_up+982} 
<ffffffff802ff180>{__log_wait_for_space+92}
[951861.616749]        <ffffffff8029dd1e>{debug_mutex_add_waiter+147} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951861.617530]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff802ff1c0>{__log_wait_for_space+156}
[951861.618314]        <ffffffff802faa5b>{start_this_handle+1015} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.619109]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802fab3e>{journal_start+136}
[951861.619871]        <ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.620291]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802fab8d>{journal_start+215}
[951861.621068]        <ffffffff802f2816>{ext3_journal_start_sb+74} 
<ffffffff802eb02e>{ext3_prepare_write+67}
[951861.627962]        <ffffffff8020f940>{generic_file_buffered_write+637}
[951861.628388]        <ffffffff8020de0b>{current_fs_time+79} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951861.629157]        <ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951861.629585]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff8022185c>{generic_file_aio_write+105}
[951861.630379]        <ffffffff802e964c>{ext3_file_write+28} 
<ffffffff80218600>{do_sync_write+237}
[951861.631139]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80235144>{do_setitimer+345}
[951861.631910]        <ffffffff80216e7a>{vfs_write+178} 
<ffffffff802461f2>{sys_pwrite64+88}
[951861.632677]        <ffffffff80262222>{system_call+126}
[951861.633380] cnid_dbd      D ffff810053189a18     0  8222   9901 
6947 (NOTLB)
[951861.634316] ffff810053189a18 ffff8100b9b9d140 ffff810025530480 
ffff810053189968
[951861.634799]        ffffffff80267b09 ffff810053189a48 
0000000000000000 000000008055e140
[951861.635614]        0000000000001a78 00035e386bf85d5f
[951861.636082] Call Trace: <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80267a0f>{_spin_lock_irqsave+16}
[951861.636910]        <ffffffff802ff180>{__log_wait_for_space+92} 
<ffffffff802ff180>{__log_wait_for_space+92}
[951861.637682]        <ffffffff80266a2c>{__mutex_lock_slowpath+414} 
<ffffffff80266cb3>{mutex_lock+38}
[951861.638476]        <ffffffff802ff180>{__log_wait_for_space+92} 
<ffffffff802faa5b>{start_this_handle+1015}
[951861.639248]        <ffffffff802070e4>{check_poison_obj+52} 
<ffffffff802121ff>{poison_obj+58}
[951861.640017]        <ffffffff802fab3e>{journal_start+136} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.640778]        <ffffffff802fab3e>{journal_start+136} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.641547]        <ffffffff802fab3e>{journal_start+136} 
<ffffffff802fab8d>{journal_start+215}
[951861.642344]        <ffffffff802f2816>{ext3_journal_start_sb+74} 
<ffffffff802ee5d1>{ext3_dirty_inode+47}
[951861.643120]        <ffffffff80213f74>{__mark_inode_dirty+45} 
<ffffffff8022a9ef>{file_update_time+186}
[951861.643891]        <ffffffff80216772>{__generic_file_aio_write_nolock+801}
[951861.644315]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff8022185c>{generic_file_aio_write+105}
[951861.645105]        <ffffffff802e964c>{ext3_file_write+28} 
<ffffffff80218600>{do_sync_write+237}
[951861.645875]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80265be2>{thread_return+179}
[951861.646651]        <ffffffff80216e7a>{vfs_write+178} 
<ffffffff802461f2>{sys_pwrite64+88}
[951861.647418]        <ffffffff80262222>{system_call+126}
[951861.648118] emerge        D ffff8101147f7348     0  8482      1 
9918 28411 (NOTLB)
[951861.649055] ffff8101147f7348 ffff8101147f7288 ffffffff8022eeea 
ffff8101147f7328
[951861.649542]        ffffffff880d9138 ffff8100f5f93208 
0000000000000000 0000000000000001
[951861.650358]        000000000000013d 00035d58458f9466
[951861.650825] Call Trace: <ffffffff8022eeea>{bio_put+49} 
<ffffffff880d9138>{:drbd:_drbd_md_sync_page_io+217}
[951861.651668]        <ffffffff80265ccd>{wait_for_completion+165} 
<ffffffff80287db7>{default_wake_function+0}
[951861.652443]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff880d9b1c>{:drbd:drbd_al_begin_io+706}
[951861.653234]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.654004]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022ed34>{blk_recount_segments+122}
[951861.654773] 
<ffffffff880d9c26>{:drbd:w_al_write_transaction+0} 
<ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.655584]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.656351]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.657123]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.657897]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.658673] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.659437]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.660207]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.660979]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802fbd0d>{do_get_write_access+1383}
[951861.661753]        <ffffffff80219dfb>{__getblk+52} 
<ffffffff802070e4>{check_poison_obj+52}
[951861.662524]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951861.663300]        <ffffffff8021612b>{alloc_pages_current+126} 
<ffffffff802a9cdd>{page_cache_alloc+23}
[951861.664070]        <ffffffff8020f8a4>{generic_file_buffered_write+481}
[951861.664492]        <ffffffff802fbd0d>{do_get_write_access+1383} 
<ffffffff8020de0b>{current_fs_time+79}
[951861.665267]        <ffffffff80219dfb>{__getblk+52} 
<ffffffff80216808>{__generic_file_aio_write_nolock+951}
[951861.666061]        <ffffffff80266b9f>{__mutex_lock_slowpath+785} 
<ffffffff8022185c>{generic_file_aio_write+105}
[951861.666854]        <ffffffff802e964c>{ext3_file_write+28} 
<ffffffff80218600>{do_sync_write+237}
[951861.667632]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80216e7a>{vfs_write+178}
[951861.668410]        <ffffffff802176f7>{sys_write+71} 
<ffffffff80262222>{system_call+126}
[951861.669459] smbd          S ffff810142881a48     0  9451   9544 
8088 (NOTLB)
[951861.670396] ffff810142881a48 ffffffff8055e140 ffffffff80267afe 
000361ae88012530
[951861.670878]        ffffffff806825c0 ffff81000c005340 
0000000000000000 0000000042881a58
[951861.671696]        00000000000024c5 000361ae88027020
[951861.672164] Call Trace: <ffffffff80267afe>{_read_unlock+9} 
<ffffffff8021d023>{__mod_timer+179}
[951861.672986]        <ffffffff8026660e>{schedule_timeout+140} 
<ffffffff80292650>{process_timeout+0}
[951861.673755]        <ffffffff80211080>{do_select+1099} 
<ffffffff8021ea22>{__pollwait+0}
[951861.674518]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.675298]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951861.676072]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff80209d31>{__link_path_walk+3412}
[951861.676843]        <ffffffff8022dc63>{mntput_no_expire+27} 
<ffffffff8020e58a>{link_path_walk+216}
[951861.677615]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802327ca>{cache_free_debugcheck+669}
[951861.678385]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8022b92a>{sys_newfstat+41}
[951861.679162]        <ffffffff80262222>{system_call+126}
[951861.679858] afpd          D ffff810137b1d348     0  9575   9910 
9633  8220 (NOTLB)
[951861.680795] ffff810137b1d348 ffff8101003335c0 0000000000011200 
0000000000000010
[951861.681276]        0000000000000001 0000000000000000 
ffff8100317f3650 0000000000000000
[951861.682091]        0000000000023b2a 00035e80ddfe37ca
[951861.682560] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.683415]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.684192]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.684970]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.685403]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.686173]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.686944]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.687712]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.688473] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.689247]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.690021]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.690791]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff80267ae8>{_spin_unlock+9}
[951861.691565]        <ffffffff802ad7e8>{try_to_free_pages+322} 
<ffffffff8020efe7>{__alloc_pages+426}
[951861.692342]        <ffffffff8021612b>{alloc_pages_current+126} 
<ffffffff802a9cfc>{page_cache_alloc_cold+29}
[951861.693115] 
<ffffffff802124d1>{__do_page_cache_readahead+182} 
<ffffffff802070e4>{check_poison_obj+52}
[951861.693891]        <ffffffff802221ef>{tcp_transmit_skb+1718} 
<ffffffff80233c98>{blockable_page_cache_readahead+93}
[951861.694679]        <ffffffff8022fced>{make_ahead_window+137} 
<ffffffff802143e9>{page_cache_readahead+393}
[951861.695451] 
<ffffffff8020b957>{do_generic_mapping_read+316} 
<ffffffff8020cbf5>{file_read_actor+0}
[951861.696233] 
<ffffffff8020bdcb>{__generic_file_aio_read+371} 
<ffffffff802171f3>{generic_file_aio_read+54}
[951861.697014]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff8041a413>{sys_sendto+295}
[951861.697784]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8020ae40>{vfs_read+175}
[951861.698570]        <ffffffff80213834>{sys_pread64+88} 
<ffffffff80262222>{system_call+126}
[951861.705735] mail.alert    S ffff810115019e98     0  9613   7184 
9614          5444 (NOTLB)
[951861.706669] ffff810115019e98 ffff810115019df8 ffffffff8029dd1e 
ffff810115018000
[951861.707151]        ffffffff8023ba87 ffff8100584a10c8 
0000000000000001 0000000100000206
[951861.707965]        000000000002b8ec 00035eaafc545277
[951861.708433] Call Trace: <ffffffff8029dd1e>{debug_mutex_add_waiter+147}
[951861.708908] 
<ffffffff8023ba87>{debug_mutex_free_waiter+133} 
<ffffffff8022258c>{__up_read+147}
[951861.709684]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.710450]        <ffffffff80245f39>{sys_rt_sigaction+140} 
<ffffffff80287db7>{default_wake_function+0}
[951861.711224]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.712270] sendmail      S ffff81005c7f1bd8     0  9614   9613 
9616               (NOTLB)
[951861.713206] ffff81005c7f1bd8 ffff81000ceb71b0 ffff81002c2f1388 
ffff81005c7f1ea8
[951861.713687]        000000000ceb71b0 0000000000000000 
0000000000000001 000000015c7f1d78
[951861.714504]        0000000000003c6d 00035eaafc496ec4
[951861.714973] Call Trace: <ffffffff8024d8db>{unix_stream_recvmsg+268}
[951861.715453]        <ffffffff8029dd1e>{debug_mutex_add_waiter+147} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951861.716225]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8023c873>{prepare_to_wait+97}
[951861.716990]        <ffffffff8024da39>{unix_stream_recvmsg+618} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.717770]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8024891a>{do_sock_read+159}
[951861.718549]        <ffffffff804199d7>{sock_aio_read+87} 
<ffffffff802201ec>{copy_process+4923}
[951861.719321]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.720099]        <ffffffff80265b94>{thread_return+101} 
<ffffffff8020ae53>{vfs_read+194}
[951861.720872]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951861.721928] postdrop      D ffff81002f67f638     0  9616   9614 
(NOTLB)
[951861.722865] ffff81002f67f638 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b 
6b6b6b6b6b6b6b6b
[951861.723351]        000000006b6b6b6b 0000000000000000 
6b6b6b6b6b6b6b6b 000000016b6b6b6b
[951861.724168]        0000000000088fc1 00035eaafc48f5ea
[951861.724636] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.725492]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.726267]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.727043]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.727474]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.728240]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.729012]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.729788]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.730549] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.731314]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.732089]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.732857]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff8020ceec>{dput+57}
[951861.733629]        <ffffffff80209d9c>{__link_path_walk+3519} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.734414]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff80221b31>{alloc_page_vma+122}
[951861.735185]        <ffffffff80208767>{__handle_mm_fault+466} 
<ffffffff802699bf>{do_page_fault+1117}
[951861.735966]        <ffffffff8023126c>{__up_write+267} 
<ffffffff80263161>{error_exit+0}
[951861.737015] afpd          S ffff81005edf3b98     0  9633   9910 
9575 (NOTLB)
[951861.737951] ffff81005edf3b98 ffff81003c319738 0000000000000007 
ffff81005edf3b18
[951861.738432]        ffffffff802327ca 0000000000000003 
0000000000000000 0000000000047580
[951861.739248]        0000000000000199 000361b5cea2053a
[951861.739716] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951861.740194]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951861.740962]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff8041bafd>{sk_wait_data+149}
[951861.741728]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80208fb6>{__d_lookup+241}
[951861.742501]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8021d97c>{tcp_recvmsg+938}
[951861.743281]        <ffffffff8023335c>{sock_common_recvmsg+47} 
<ffffffff8024891a>{do_sock_read+159}
[951861.744050]        <ffffffff804199d7>{sock_aio_read+87} 
<ffffffff802121ff>{poison_obj+58}
[951861.744811]        <ffffffff8020c99c>{do_sync_read+237} 
<ffffffff80263161>{error_exit+0}
[951861.745571]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff80245dfd>{sys_rt_sigreturn+582}
[951861.746350]        <ffffffff8020ae53>{vfs_read+194} 
<ffffffff8021122a>{sys_read+71}
[951861.747120]        <ffffffff80262222>{system_call+126}
[951861.747818] pickup        S ffff81002e7d7a48     0  9697   7444 
7459 (NOTLB)
[951861.748754] ffff81002e7d7a48 ffff8100f7c8a860 00002b2e2ceff000 
000361a930cf20f7
[951861.749236]        ffffffff806825c0 ffff81000c005340 
0000000000000000 000000002e7d7a58
[951861.750053]        00000000000000a9 000361a930cf26f0
[951861.750521] Call Trace: <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.751351]        <ffffffff80292650>{process_timeout+0} 
<ffffffff80211080>{do_select+1099}
[951861.752123]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.752892]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287dc4>{default_wake_function+13}
[951861.753670]        <ffffffff80287e09>{__wake_up_common+67} 
<ffffffff8022f052>{__wake_up+65}
[951861.754438]        <ffffffff80267afe>{_read_unlock+9} 
<ffffffff802126ca>{sock_def_readable+106}
[951861.755208]        <ffffffff8024d71a>{unix_stream_sendmsg+587} 
<ffffffff80239408>{do_sock_write+163}
[951861.755987]        <ffffffff8024a41a>{sock_aio_write+87} 
<ffffffff802121ff>{poison_obj+58}
[951861.756755]        <ffffffff8026fa86>{do_gettimeofday+84} 
<ffffffff80216c08>{sys_select+710}
[951861.757525]        <ffffffff8023e208>{hrtimer_start+192} 
<ffffffff80267b09>{_spin_unlock_irq+9}
[951861.758292]        <ffffffff80235144>{do_setitimer+345} 
<ffffffff80262222>{system_call+126}
[951861.759333] emerge        D ffff81003fa13638     0  9918      1 
9924  8482 (NOTLB)
[951861.760267] ffff81003fa13638 0000000000000000 0000000000000000 
0000000000000000
[951861.760749]        0000000000000000 0000000000000000 
0000000000000000 0000000100000000
[951861.761566]        00000000002edcb7 000360edbe965129
[951861.762035] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.762895]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.763671]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.764450]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.764882]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.765650]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.766420]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.767201]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.767967] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.768738]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.769512]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.770281]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff8022dc63>{mntput_no_expire+27}
[951861.771057]        <ffffffff80209d31>{__link_path_walk+3412} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.771842]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff80221b31>{alloc_page_vma+122}
[951861.772613]        <ffffffff80208767>{__handle_mm_fault+466} 
<ffffffff802699bf>{do_page_fault+1117}
[951861.773387]        <ffffffff80223b66>{sys_newstat+49} 
<ffffffff80263161>{error_exit+0}
[951861.774429] sshd          D ffff8100927bd638     0  9924      1 
10126  9918 (NOTLB)
[951861.775366] ffff8100927bd638 898b948e97908c92 8480828a81808684 
8b9196838a838281
[951861.775850]        7e888c8f919a9ba5 836a79766a6e6e86 
0000000000000001 0000000195939d99
[951861.776668]        000000000000773d 000360ef6cab6391
[951861.783251] Call Trace: <ffffffff880dbc8d>{:drbd:lc_find+55} 
<ffffffff880d99f4>{:drbd:drbd_al_begin_io+410}
[951861.784109]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802237b5>{mempool_alloc+73}
[951861.784887]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff802c0d6d>{__bio_clone+126}
[951861.785665]        <ffffffff880d8c4c>{:drbd:drbd_make_request_26+1880}
[951861.786095]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8022226a>{dbg_redzone1+32}
[951861.786861]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8020c0a7>{cache_alloc_debugcheck_after+355}
[951861.787626]        <ffffffff802aabdd>{mempool_alloc_slab+17} 
<ffffffff8021c51d>{generic_make_request+539}
[951861.788395]        <ffffffff80234d09>{submit_bio+203} 
<ffffffff8021abd8>{submit_bh+267}
[951861.789161] 
<ffffffff8021c713>{__block_write_full_page+475} 
<ffffffff802c2bd5>{blkdev_get_block+0}
[951861.789933]        <ffffffff802c2bd5>{blkdev_get_block+0} 
<ffffffff802174a1>{block_write_full_page+157}
[951861.790722]        <ffffffff802c2cfa>{blkdev_writepage+19} 
<ffffffff80246f8e>{pageout+308}
[951861.791494]        <ffffffff80212f35>{shrink_zone+2139} 
<ffffffff802121ff>{poison_obj+58}
[951861.792260]        <ffffffff802121ff>{poison_obj+58} 
<ffffffff802ad7e8>{try_to_free_pages+322}
[951861.793039]        <ffffffff8020efe7>{__alloc_pages+426} 
<ffffffff80221b31>{alloc_page_vma+122}
[951861.793811]        <ffffffff80208767>{__handle_mm_fault+466} 
<ffffffff802699bf>{do_page_fault+1117}
[951861.794604]        <ffffffff8020aeae>{vfs_read+285} 
<ffffffff80263161>{error_exit+0}
[951861.795648] sshd          S ffff8101033a1bd8     0  9936   6597 
9941    9951       (NOTLB)
[951861.796585] ffff8101033a1bd8 0000000000000246 0000000000000000 
0000000000000001
[951861.797065]        ffff81002b48b118 0000000000000246 
0000000000000000 0000000000000004
[951861.797882]        0000000000015c16 0003610a22115dbe
[951861.798350] Call Trace: <ffffffff8024d8db>{unix_stream_recvmsg+268}
[951861.798830] 
<ffffffff8023ba87>{debug_mutex_free_waiter+133} 
<ffffffff802665a4>{schedule_timeout+34}
[951861.799611]        <ffffffff8023c873>{prepare_to_wait+97} 
<ffffffff8024da39>{unix_stream_recvmsg+618}
[951861.800402]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.801181]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951861.801940]        <ffffffff80216228>{get_unused_fd+248} 
<ffffffff8020c99c>{do_sync_read+237}
[951861.802705]        <ffffffff8024c56e>{chrdev_open+396} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.803481]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff8020ae53>{vfs_read+194}
[951861.804256]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951861.805310] sshd          S ffff8100dc07fa48     0  9941   9936 
9942               (NOTLB)
[951861.806244] ffff8100dc07fa48 0000000000000000 ffff81012daab3b8 
ffff8100dc07fbf8
[951861.806726]        ffff8100dc07fc00 ffff810017e3b350 
0000000000000001 0000000100000246
[951861.807544]        00000000000010ae 000361b6181e5d8b
[951861.808012] Call Trace: <ffffffff8022f052>{__wake_up+65} 
<ffffffff802665a4>{schedule_timeout+34}
[951861.808845]        <ffffffff802261fd>{tty_poll+102} 
<ffffffff80211080>{do_select+1099}
[951861.809612]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.810380]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.811158]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951861.811928]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951861.812700]        <ffffffff802480ed>{inet_sendmsg+70} 
<ffffffff80239408>{do_sock_write+163}
[951861.813470]        <ffffffff8024a41a>{sock_aio_write+87} 
<ffffffff8022f052>{__wake_up+65}
[951861.814239]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.815014]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff802176f7>{sys_write+71}
[951861.815784]        <ffffffff80262222>{system_call+126}
[951861.816476] bash          S ffff81010fe51e98     0  9942   9941 
10189               (NOTLB)
[951861.817408] ffff81010fe51e98 ffff81010fe51dd8 ffffffff80287dc4 
ffff81010fe51df8
[951861.817890]        ffffffff8029b2f6 ffff81017f926000 
0000000000000001 0000000100000202
[951861.818708]        000000000000bbde 000361b5c5b04b6f
[951861.819176] Call Trace: <ffffffff80287dc4>{default_wake_function+13}
[951861.819656] 
<ffffffff8029b2f6>{autoremove_wake_function+15} 
<ffffffff8022258c>{__up_read+147}
[951861.820431]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.821215]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80287db7>{default_wake_function+0}
[951861.821992]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.823037] sshd          S ffff810100a47bd8     0  9951   6597 
9956          9936 (NOTLB)
[951861.823974] ffff810100a47bd8 0000000000000246 0000000000000000 
0000000000000001
[951861.824455]        ffff81001cef38a8 0000000000000246 
0000000000000000 0000000000000004
[951861.825270]        00000000000164ae 0003610ffa1a4109
[951861.825738] Call Trace: <ffffffff8024d8db>{unix_stream_recvmsg+268}
[951861.826219] 
<ffffffff8023ba87>{debug_mutex_free_waiter+133} 
<ffffffff802665a4>{schedule_timeout+34}
[951861.826999]        <ffffffff8023c873>{prepare_to_wait+97} 
<ffffffff8024da39>{unix_stream_recvmsg+618}
[951861.827787]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.828569]        <ffffffff8024891a>{do_sock_read+159} 
<ffffffff804199d7>{sock_aio_read+87}
[951861.829337]        <ffffffff80216228>{get_unused_fd+248} 
<ffffffff8020c99c>{do_sync_read+237}
[951861.830102]        <ffffffff8024c56e>{chrdev_open+396} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.830872]        <ffffffff802327ca>{cache_free_debugcheck+669} 
<ffffffff8020ae53>{vfs_read+194}
[951861.831644]        <ffffffff8021122a>{sys_read+71} 
<ffffffff80262222>{system_call+126}
[951861.832694] sshd          S ffff810088feda48     0  9956   9951 
9957               (NOTLB)
[951861.833630] ffff810088feda48 0000000000000000 ffff81005c7c1178 
ffff810088fedbf8
[951861.834112]        0000000088fedc00 0000000000000000 
ffff8100f616ad60 0000000100000246
[951861.834928]        00000000000011fe 0003611090ca35db
[951861.835396] Call Trace: <ffffffff8022f052>{__wake_up+65} 
<ffffffff802665a4>{schedule_timeout+34}
[951861.836227]        <ffffffff802261fd>{tty_poll+102} 
<ffffffff80211080>{do_select+1099}
[951861.836996]        <ffffffff8021ea22>{__pollwait+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.837765]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80287db7>{default_wake_function+0}
[951861.838543]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80267b1a>{_spin_unlock_bh+14}
[951861.839318]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff80226c0a>{tcp_sendmsg+2555}
[951861.840089]        <ffffffff802480ed>{inet_sendmsg+70} 
<ffffffff80239408>{do_sock_write+163}
[951861.840858]        <ffffffff8024a41a>{sock_aio_write+87} 
<ffffffff8022f052>{__wake_up+65}
[951861.841633]        <ffffffff80216c08>{sys_select+710} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.842408]        <ffffffff80267ae8>{_spin_unlock+9} 
<ffffffff802176f7>{sys_write+71}
[951861.843182]        <ffffffff80262222>{system_call+126}
[951861.843892] bash          S ffff8101027f1e98     0  9957   9956 
9962               (NOTLB)
[951861.844821] ffff8101027f1e98 ffff8101027f1e78 ffffffff802201ec 
0000000000000016
[951861.845299]        ffff81003e77bc18 ffff81017f926000 
0000000000000001 0000000100000212
[951861.846116]        0000000000004295 00036110900edce9
[951861.846584] Call Trace: <ffffffff802201ec>{copy_process+4923} 
<ffffffff8022258c>{__up_read+147}
[951861.847423]        <ffffffff80228826>{do_wait+2714} 
<ffffffff80287db7>{default_wake_function+0}
[951861.848195]        <ffffffff80267b09>{_spin_unlock_irq+9} 
<ffffffff80287db7>{default_wake_function+0}
[951861.848970]        <ffffffff8025845f>{sys_wait4+40} 
<ffffffff80262222>{system_call+126}
[951861.850014] bash          S ffff810132555d88     0  9962   9957 
(NOTLB)
[951861.850952] ffff810132555d88 ffff8100c847f590 ffff81005c7c17a0 
ffff810132555dc8
[951861.851434]        ffffffff802151a3 ffff810100001d10 
0000000000000001 0000000100001d10
[951861.852251]        00000000000004fd 0003611090ca53cc
[951861.852721] Call Trace: <ffffffff802151a3>{n_tty_receive_buf+3468}
[951861.853195]        <ffffffff80229c96>{read_chan+607} 
<ffffffff8023ba87>{debug_mutex_free_waiter+133}
[951861.853975]        <ffffffff802665a4>{schedule_timeout+34} 
<ffffffff8024cb90>{add_wait_queue+63}
[951861.854747]        <ffffffff80229e72>{read_chan+1083} 
<ffffffff80287db7>{default_wake_function+0}
[951861.861632]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80233d87>{tty_read+143}
[951861.862410]        <ffffffff8020ae40>{vfs_read+175} 
<ffffffff8021122a>{sys_read+71}
[951861.863176]        <ffffffff80262222>{system_call+126}
[951861.863878] drbd6_worker  S ffff810121f9bdf8     0 10126      1 
10142  9924 (L-TLB)
[951861.864812] ffff810121f9bdf8 ffffffff8055e140 ffffffff8058aee0 
ffff810121f9a000
[951861.865300]        0000000021f9bde8 0000000000000000 
0000000000000000 00000000ffffffff
[951861.866117]        00000000000001cb 0003617aa7706709
[951861.866583] Call Trace: <ffffffff80267925>{__down_interruptible+219}
[951861.867064]        <ffffffff80287db7>{default_wake_function+0} 
<ffffffff80267619>{__down_failed_interruptible+53}
[951861.867847]        <ffffffff880d218f>{:drbd:drbd_worker+1023} 
<ffffffff880d5bbf>{:drbd:receive_bitmap+0}
[951861.868654] 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207} 
<ffffffff8026331a>{child_rip+8}
[951861.869434]        <ffffffff880d5bbf>{:drbd:receive_bitmap+0} 
<ffffffff880dc62b>{:drbd:drbd_thread_setup+0}
[951861.870241]        <ffffffff80263312>{child_rip+0}
[951861.870945] drbd6_asender S ffff810056a37b48     0 10142      1 
10143 10126 (L-TLB)
[951861.871881] ffff810056a37b48 ffff81003c319e00 000000000000000e 
ffff810056a37ac8
[951861.872363]        ffffffff802327ca ffff81000c005340 
0000000000000000 0000000056a37b58
[951861.873172]        0000000000000179 000361b4a729bd97
[951861.873636] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951861.874118]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.874884]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8041bafd>{sk_wait_data+149}
[951861.875658]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.876440]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.877214]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff804197db>{kernel_sendmsg+59}
[951861.877986]        <ffffffff880dcd2c>{:drbd:drbd_send+155} 
<ffffffff880d278e>{:drbd:_drbd_process_ee+435}
[951861.878783]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff880d7d96>{:drbd:drbd_asender+510}
[951861.879577] 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207} 
<ffffffff8026331a>{child_rip+8}
[951861.880361]        <ffffffff880dc62b>{:drbd:drbd_thread_setup+0} 
<ffffffff80263312>{child_rip+0}
[951861.881419] drbd0_asender S ffff8100990e5b48     0 10143      1 
10144 10142 (L-TLB)
[951861.882357] ffff8100990e5b48 ffff8100551cb830 0000000000000008 
ffff8100990e5ac8
[951861.882840]        ffffffff802327ca ffff81010002d340 
0000000000000001 00000001990e5b58
[951861.883656]        00000000000004cc 000361b4bd4cf5aa
[951861.884125] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951861.884604]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.885368]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8041bafd>{sk_wait_data+149}
[951861.886141]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.886917]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.887684]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff804197db>{kernel_sendmsg+59}
[951861.888453]        <ffffffff880dcd2c>{:drbd:drbd_send+155} 
<ffffffff880d278e>{:drbd:_drbd_process_ee+435}
[951861.889255]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff880d7d96>{:drbd:drbd_asender+510}
[951861.890048] 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207} 
<ffffffff8026331a>{child_rip+8}
[951861.890832]        <ffffffff880dc62b>{:drbd:drbd_thread_setup+0} 
<ffffffff80263312>{child_rip+0}
[951861.891891] drbd2_asender S ffff8100c5a11b48     0 10144      1 
10145 10143 (L-TLB)
[951861.892828] ffff8100c5a11b48 ffff8100c3902640 0000000000000006 
ffff8100c5a11ac8
[951861.893312]        ffffffff802327ca ffff81010002d340 
0000000000000001 00000001c5a11b58
[951861.894128]        00000000000004c7 000361b44d31d830
[951861.894596] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951861.895080]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.895846]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8041bafd>{sk_wait_data+149}
[951861.896620]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.897403]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.898179]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff804197db>{kernel_sendmsg+59}
[951861.898948]        <ffffffff880dcd2c>{:drbd:drbd_send+155} 
<ffffffff880d278e>{:drbd:_drbd_process_ee+435}
[951861.899749]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff880d7d96>{:drbd:drbd_asender+510}
[951861.900542] 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207} 
<ffffffff8026331a>{child_rip+8}
[951861.901323]        <ffffffff880dc62b>{:drbd:drbd_thread_setup+0} 
<ffffffff80263312>{child_rip+0}
[951861.902370] drbd1_asender S ffff81010f391b48     0 10145      1 
10146 10144 (L-TLB)
[951861.903309] ffff81010f391b48 ffff810095322640 0000000000000006 
ffff81010f391ac8
[951861.903794]        ffffffff802327ca ffff81010002d340 
0000000000000001 000000010f391b58
[951861.904609]        0000000000000337 000361b4de9fde55
[951861.905077] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951861.905561]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.906326]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8041bafd>{sk_wait_data+149}
[951861.907098]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.907879]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.908655]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff804197db>{kernel_sendmsg+59}
[951861.909426]        <ffffffff880dcd2c>{:drbd:drbd_send+155} 
<ffffffff880d278e>{:drbd:_drbd_process_ee+435}
[951861.910227]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff880d7d96>{:drbd:drbd_asender+510}
[951861.911020] 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207} 
<ffffffff8026331a>{child_rip+8}
[951861.911807]        <ffffffff880dc62b>{:drbd:drbd_thread_setup+0} 
<ffffffff80263312>{child_rip+0}
[951861.912867] drbd3_asender S ffff810052fc1b48     0 10146      1 
10147 10145 (L-TLB)
[951861.913805] ffff810052fc1b48 ffff8100c3902640 0000000000000006 
ffff810052fc1ac8
[951861.914287]        ffffffff802327ca ffff81000c005340 
0000000000000000 0000000052fc1b58
[951861.915105]        0000000000000135 000361b44d306be3
[951861.915570] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951861.916051]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.916811]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8041bafd>{sk_wait_data+149}
[951861.917585]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.918366]        <ffffffff8021d97c>{tcp_recvmsg+938} 
<ffffffff8023335c>{sock_common_recvmsg+47}
[951861.919143]        <ffffffff8023150f>{sock_recvmsg+244} 
<ffffffff804197db>{kernel_sendmsg+59}
[951861.919913]        <ffffffff880dcd2c>{:drbd:drbd_send+155} 
<ffffffff880d278e>{:drbd:_drbd_process_ee+435}
[951861.920715]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff880d7d96>{:drbd:drbd_asender+510}
[951861.921508] 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207} 
<ffffffff8026331a>{child_rip+8}
[951861.922293]        <ffffffff880dc62b>{:drbd:drbd_thread_setup+0} 
<ffffffff80263312>{child_rip+0}
[951861.923352] drbd7_asender S ffff810063987b48     0 10147      1 
10146 (L-TLB)
[951861.924288] ffff810063987b48 ffff81003c319260 0000000000000002 
ffff810063987ac8
[951861.924768]        ffffffff802327ca ffff81000c005340 
0000000000000000 0000000063987b58
[951861.925586]        000000000000020b 000361b5080bc67a
[951861.926053] Call Trace: <ffffffff802327ca>{cache_free_debugcheck+669}
[951861.926533]        <ffffffff8021d023>{__mod_timer+179} 
<ffffffff8026660e>{schedule_timeout+140}
[951861.927300]        <ffffffff80292650>{process_timeout+0} 
<ffffffff8041bafd>{sk_wait_data+149}
[951861.928073]        <ffffffff8029b2e7>{autoremove_wake_function+0} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.928853]        <ffffffff80231e6f>{release_sock+191} 
<ffffffff8021d97c>{tcp_recvmsg+938}
[951861.929617]        <ffffffff8023335c>{sock_common_recvmsg+47} 
<ffffffff8023150f>{sock_recvmsg+244}
[951861.930378]        <ffffffff804197db>{kernel_sendmsg+59} 
<ffffffff880dcd2c>{:drbd:drbd_send+155}
[951861.931160]        <ffffffff880d278e>{:drbd:_drbd_process_ee+435} 
<ffffffff8029b2e7>{autoremove_wake_function+0}
[951861.931954]        <ffffffff880d7d96>{:drbd:drbd_asender+510} 
<ffffffff880dc6fa>{:drbd:drbd_thread_setup+207}
[951861.932754]        <ffffffff8026331a>{child_rip+8} 
<ffffffff880dc62b>{:drbd:drbd_thread_setup+0}
[951861.933538]        <ffffffff80263312>{child_rip+0}
[951861.940345] bash          R  running task       0 10189   9942 
(NOTLB)
[951861.941281]
[951861.941282] Showing all blocking locks in the system:
[951861.941866] S            init:    1 [ffff8100f7f62760, 116] (not 
blocked on mutex)
[951861.942515] S     migration/0:    2 [ffff810100051040,   0] (not 
blocked on mutex)
[951861.943165] S     ksoftirqd/0:    3 [ffff810100051760, 134] (not 
blocked on mutex)
[951861.943811] S      watchdog/0:    4 [ffff810100054080,   0] (not 
blocked on mutex)
[951861.944453] S     migration/1:    5 [ffff8101000547a0,   0] (not 
blocked on mutex)
[951861.945095] S     ksoftirqd/1:    6 [ffff8101000850c0, 134] (not 
blocked on mutex)
[951861.945745] S      watchdog/1:    7 [ffff8101000857e0,   0] (not 
blocked on mutex)
[951861.946394] S        events/0:    8 [ffff810100086820, 110] (not 
blocked on mutex)
[951861.947043] S        events/1:    9 [ffff8101002f1140, 110] (not 
blocked on mutex)
[951861.947694] S         khelper:   10 [ffff8100f7f62040, 110] (not 
blocked on mutex)
[951861.948344] S         kthread:   11 [ffff810037fe67a0, 110] (not 
blocked on mutex)
[951861.948992] S       kblockd/0:   16 [ffff81010008a040, 110] (not 
blocked on mutex)
[951861.949644] S       kblockd/1:   17 [ffff8101000897a0, 110] (not 
blocked on mutex)
[951861.950296] S         kseriod:   18 [ffff810100089080, 110] (not 
blocked on mutex)
[951861.950946] D         kswapd0:  108 [ffff810037fe6080, 115] (not 
blocked on mutex)
[951861.951598] D         kswapd1:  109 [ffff81017de38100, 115] (not 
blocked on mutex)
[951861.952249] S           aio/0:  110 [ffff81010008b180, 111] (not 
blocked on mutex)
[951861.952900] S           aio/1:  111 [ffff81010008b8a0, 111] (not 
blocked on mutex)
[951861.953551] S       scsi_eh_0:  746 [ffff8101002f1860, 111] (not 
blocked on mutex)
[951861.954203] S           ata/0:  750 [ffff81017ddc50c0, 111] (not 
blocked on mutex)
[951861.954854] S           ata/1:  751 [ffff81017de38820, 111] (not 
blocked on mutex)
[951861.955506] S       kpsmoused:  774 [ffff81017dda7860, 110] (not 
blocked on mutex)
[951861.956158] S        kmirrord: 1380 [ffff81017dff97a0, 112] (not 
blocked on mutex)
[951861.956810] S       scsi_eh_1: 1918 [ffff81017dfd9820, 111] (not 
blocked on mutex)
[951861.957459] S       kjournald: 2136 [ffff81017dda7140, 110] (not 
blocked on mutex)
[951861.958107] S           udevd: 2801 [ffff8100f7d86820, 112] (not 
blocked on mutex)
[951861.958751] S       kjournald: 3842 [ffff81017dd8b100, 110] (not 
blocked on mutex)
[951861.959393] S       kjournald: 3844 [ffff81017de63860, 110] (not 
blocked on mutex)
[951861.960044] S         metalog: 5638 [ffff810037ea9140, 115] (not 
blocked on mutex)
[951861.960695] R         metalog: 5639 [ffff81017dfee100, 116] (not 
blocked on mutex)
[951861.961343] S            sshd: 6597 [ffff81017d54d040, 115] (not 
blocked on mutex)
[951861.961994] S  drbd0_receiver: 6767 [ffff81017dc55100, 115] (not 
blocked on mutex)
[951861.962645] S  drbd1_receiver: 6769 [ffff81017d64c140, 115] (not 
blocked on mutex)
[951861.963292] S  drbd7_receiver: 6771 [ffff810037ea9860, 115] (not 
blocked on mutex)
[951861.963941] S  drbd2_receiver: 6773 [ffff81017de21760, 115] (not 
blocked on mutex)
[951861.964593] S  drbd3_receiver: 6775 [ffff8101002d27a0, 115] (not 
blocked on mutex)
[951861.965246] D  drbd8_receiver: 6777 [ffff8101002c77e0, 115] (not 
blocked on mutex)
[951861.965897] D  drbd4_receiver: 6779 [ffff81017dc5a820, 115] (not 
blocked on mutex)
[951861.966544] D  drbd5_receiver: 6781 [ffff810037ec1100, 115] (not 
blocked on mutex)
[951861.967195] S  drbd6_receiver: 6783 [ffff8100f7d86100, 115] (not 
blocked on mutex)
[951861.967847] S       heartbeat: 7013 [ffff8100ee3667e0,  98] (not 
blocked on mutex)
[951861.968494] ?       heartbeat: 7035 [ffff8100ee2d88a0,  98] (not 
blocked on mutex)
[951861.969145] S       heartbeat: 7036 [ffff8100ee1b7140,  98] (not 
blocked on mutex)
[951861.969795] S       heartbeat: 7037 [ffff8100ee31d080,  98] (not 
blocked on mutex)
[951861.970447] S             mon: 7184 [ffff81017dccf8a0, 117] (not 
blocked on mutex)
[951861.971098] S      portsentry: 7327 [ffff8100eddda080, 115] (not 
blocked on mutex)
[951861.971747] S      portsentry: 7329 [ffff8100ee1f07a0, 115] (not 
blocked on mutex)
[951861.972393] S          master: 7444 [ffff8100f7c8a860, 116] (not 
blocked on mutex)
[951861.973036] S            qmgr: 7459 [ffff81017dd40820, 116] (not 
blocked on mutex)
[951861.973681] S            cron: 7589 [ffff8100ec1d27e0, 116] (not 
blocked on mutex)
[951861.974332] S          agetty: 7717 [ffff8100ee251040, 117] (not 
blocked on mutex)
[951861.974982] S          agetty: 7718 [ffff8100eddda7a0, 116] (not 
blocked on mutex)
[951861.975630] S          agetty: 7719 [ffff8100ee251760, 116] (not 
blocked on mutex)
[951861.976283] S          agetty: 7720 [ffff8100ee2070c0, 116] (not 
blocked on mutex)
[951861.976933] S          agetty: 7721 [ffff8100ee31d7a0, 116] (not 
blocked on mutex)
[951861.977584] S          agetty: 7722 [ffff8100ee220760, 117] (not 
blocked on mutex)
[951861.978236] S       kjournald: 8923 [ffff81017d03a040, 110] (not 
blocked on mutex)
[951861.978887] S       kjournald: 8971 [ffff81017d03a760, 110] (not 
blocked on mutex)
[951861.979539] S       kjournald: 9019 [ffff81017a81a080, 110] (not 
blocked on mutex)
[951861.980189] S       kjournald: 9067 [ffff81017a81a7a0, 110] (not 
blocked on mutex)
[951861.980841] D       kjournald: 9115 [ffff8101001cd0c0, 110] (not 
blocked on mutex)
[951861.981491] S       kjournald: 9163 [ffff8101001cd7e0, 110] (not 
blocked on mutex)
[951861.982143] S       kjournald: 9211 [ffff81017a848100, 110] (not 
blocked on mutex)
[951861.982793] S       kjournald: 9259 [ffff81017a848820, 110] (not 
blocked on mutex)
[951861.983445] D       kjournald: 9307 [ffff81017a9a7140, 110] (not 
blocked on mutex)
[951861.984096] S          atalkd: 9438 [ffff8100eb46f7a0, 116] (not 
blocked on mutex)
[951861.984747] S            smbd: 9544 [ffff8100ebdc58a0, 116] (not 
blocked on mutex)
[951861.985398] S            smbd: 9548 [ffff8100ebdc5180, 120] (not 
blocked on mutex)
[951861.986048] S            nmbd: 9554 [ffff8100ebe37080, 116] (not 
blocked on mutex)
[951861.986695] S          mysqld: 9688 [ffff8101002c70c0, 116] (not 
blocked on mutex)
[951861.987339] S          mysqld: 9734 [ffff8100ebdad860, 123] (not 
blocked on mutex)
[951861.987982] S          mysqld: 9735 [ffff8100ee1c5820, 117] (not 
blocked on mutex)
[951861.988634] S          mysqld: 9736 [ffff8100ebf5b820, 116] (not 
blocked on mutex)
[951861.989287] S          mysqld: 9737 [ffff8100ebf5b100, 116] (not 
blocked on mutex)
[951861.989938] S          mysqld: 9819 [ffff8100eb472760, 116] (not 
blocked on mutex)
[951861.990588] S          mysqld: 9820 [ffff8100f7c868a0, 116] (not 
blocked on mutex)
[951861.991238] S          mysqld: 9821 [ffff8100ee1f0080, 116] (not 
blocked on mutex)
[951861.991890] S          mysqld: 9822 [ffff8100ee2077e0, 115] (not 
blocked on mutex)
[951861.992542] S      cnid_metad: 9901 [ffff8100ebf3f760, 116] (not 
blocked on mutex)
[951861.993194] S            afpd: 9910 [ffff8100eb472040, 117] (not 
blocked on mutex)
[951861.993847] S     retroclient:11332 [ffff8100ebdad140, 116] (not 
blocked on mutex)
[951861.994498] S     retroclient:11333 [ffff81017dd40100, 115] (not 
blocked on mutex)
[951861.995149] S     retroclient:11335 [ffff81017dd8b820, 116] (not 
blocked on mutex)
[951861.995800] S     retroclient:11336 [ffff81017dc5a100, 115] (not 
blocked on mutex)
[951861.996451] S     retroclient:11337 [ffff81010022a760, 124] (not 
blocked on mutex)
[951861.997103] S     retroclient:11344 [ffff81017d54d760, 117] (not 
blocked on mutex)
[951861.997756] S     retroclient:11345 [ffff81017dfd9100, 117] (not 
blocked on mutex)
[951861.998408] S     retroclient:11352 [ffff81017dfee820, 117] (not 
blocked on mutex)
[951862.005174] S     retroclient:11353 [ffff81017dc55820, 117] (not 
blocked on mutex)
[951862.005825] S     retroclient:11360 [ffff81017a9a7860, 115] (not 
blocked on mutex)
[951862.006477] S     retroclient:11365 [ffff8101002d2080, 116] (not 
blocked on mutex)
[951862.007128] S        cnid_dbd:11908 [ffff8100ebf3f040, 116] (not 
blocked on mutex)
[951862.007776] S            smbd: 8270 [ffff8100eb46f080, 116] (not 
blocked on mutex)
[951862.008428] D            smbd:10289 [ffff8100ee1c5100, 116] (not 
blocked on mutex)
[951862.009077] S            smbd:31891 [ffff81010d8d5180, 116] (not 
blocked on mutex)
[951862.009728] D            smbd:29010 [ffff81007eb63140, 116] (not 
blocked on mutex)
[951862.010378] S            smbd:24530 [ffff81006e10c040, 116] (not 
blocked on mutex)
[951862.011029] S         pdflush:32250 [ffff8101678260c0, 115] (not 
blocked on mutex)
[951862.011679] D         pdflush:19751 [ffff8101150990c0, 115] (not 
blocked on mutex)
[951862.012329] S            afpd: 3856 [ffff8101075958a0, 115] (not 
blocked on mutex)
[951862.012980] S            smbd: 8543 [ffff81017ddc57e0, 116] (not 
blocked on mutex)
[951862.013631] S            afpd:11364 [ffff81006e10c760, 115] (not 
blocked on mutex)
[951862.014282] S            afpd:27917 [ffff8100ee220040, 115] (not 
blocked on mutex)
[951862.014933] S        cnid_dbd:27918 [ffff8100ec1d20c0, 115] (not 
blocked on mutex)
[951862.015576] S            smbd:22538 [ffff81010008a760, 116] (not 
blocked on mutex)
[951862.016219] S            smbd:12830 [ffff81006077e080, 116] (not 
blocked on mutex)
[951862.016870] S            smbd:17962 [ffff8100ee2d8180, 116] (not 
blocked on mutex)
[951862.017522] S            smbd:23331 [ffff8101421f18a0, 116] (not 
blocked on mutex)
[951862.018173] S            smbd:28361 [ffff81017de21040, 116] (not 
blocked on mutex)
[951862.018821] S            bash:28411 [ffff8100ca960140, 115] (not 
blocked on mutex)
[951862.019471] S            smbd: 3404 [ffff810169e70820, 116] (not 
blocked on mutex)
[951862.020122] S            smbd:13660 [ffff81017d64c860, 116] (not 
blocked on mutex)
[951862.020772] S       kjournald:27168 [ffff8101463db100, 110] (not 
blocked on mutex)
[951862.021422] S            smbd:25449 [ffff81015fde10c0, 116] (not 
blocked on mutex)
[951862.022072] S            smbd:28328 [ffff81010c86f760, 116] (not 
blocked on mutex)
[951862.022723] S         apache2:32490 [ffff81002154c180, 115] (not 
blocked on mutex)
[951862.023375] S         apache2:24761 [ffff81015cca7820, 117] (not 
blocked on mutex)
[951862.024027] S         apache2:24764 [ffff810177d900c0, 116] (not 
blocked on mutex)
[951862.024677] S         apache2:24765 [ffff8100e47b1080, 116] (not 
blocked on mutex)
[951862.025329] S         apache2:24766 [ffff81016ae0f860, 116] (not 
blocked on mutex)
[951862.025980] S         apache2:24767 [ffff81013232b040, 116] (not 
blocked on mutex)
[951862.026633] S         apache2:24768 [ffff810036ee27e0, 115] (not 
blocked on mutex)
[951862.027285] S            smbd: 2091 [ffff81013f909040, 116] (not 
blocked on mutex)
[951862.027935] S            smbd:10197 [ffff8101195a87e0, 116] (not 
blocked on mutex)
[951862.028586] S            smbd:10832 [ffff81016ae0f140, 116] (not 
blocked on mutex)
[951862.029238] S            smbd:15513 [ffff81011a396040, 116] (not 
blocked on mutex)
[951862.029882] S            smbd:19215 [ffff8100ee3660c0, 116] (not 
blocked on mutex)
[951862.030526] S            smbd:19585 [ffff81003ea138a0, 116] (not 
blocked on mutex)
[951862.031176] D            smbd:19761 [ffff81000f512040, 116] (not 
blocked on mutex)
[951862.031827] S         apache2:21619 [ffff810112e72180, 115] (not 
blocked on mutex)
[951862.032476] S         apache2:21620 [ffff810036ee20c0, 116] (not 
blocked on mutex)
[951862.033127] S            smbd:30680 [ffff81012a647140, 116] (not 
blocked on mutex)
[951862.033778] S            smbd:31724 [ffff8100ee1b7860, 116] (not 
blocked on mutex)
[951862.034429] S            afpd:32105 [ffff81000f512760, 115] (not 
blocked on mutex)
[951862.035081] S            smbd: 8343 [ffff810107595180, 116] (not 
blocked on mutex)
[951862.035731] S            afpd:17100 [ffff81013f909760, 115] (not 
blocked on mutex)
[951862.036383] S     retroclient:14374 [ffff81014b71f7a0, 116] (not 
blocked on mutex)
[951862.037034] D     retropds.23:14376 [ffff810095674860, 117] (not 
blocked on mutex)
[951862.037684] ?     retroclient:14397 [ffff81013232b760, 117] (not 
blocked on mutex)
[951862.038336] ?            cron:27942 [ffff8101195a80c0, 117] (not 
blocked on mutex)
[951862.038985] S            bash:27943 [ffff8100ca960860, 119] (not 
blocked on mutex)
[951862.039637] S       run-crons:27944 [ffff81015c9b7760, 117] (not 
blocked on mutex)
[951862.040288] S hotbackup_daily:27973 [ffff81012eeb8820, 115] (not 
blocked on mutex)
[951862.040938] S hotbackup_daily:27976 [ffff810095674140, 124] (not 
blocked on mutex)
[951862.041590] ?        sendmail:28053 [ffff8101701d47e0, 116] (not 
blocked on mutex)
[951862.042241] S        postdrop:28056 [ffff8101004ca7e0, 116] (not 
blocked on mutex)
[951862.042890] D              mv:28058 [ffff810177d907e0, 124] (not 
blocked on mutex)
[951862.043542] D            find:28509 [ffff8100d2dc3080, 117] (not 
blocked on mutex)
[951862.044185] ?            sort:28512 [ffff810137d22860, 115] (not 
blocked on mutex)
[951862.044828] ?             sed:28514 [ffff8100a71807e0, 115] (not 
blocked on mutex)
[951862.045478] S         slocate:12803 [ffff8100d639b080, 117] (not 
blocked on mutex)
[951862.046129] D        updatedb:12804 [ffff810161c15860, 126] 
blocked on mutex: [ffff81009cda73c8] {inode_init_once}
[951862.046853] .. held by:              find:28509 [ffff8100d2dc3080, 117]
[951862.047277] ... acquired at:               0x0
[951862.047647] D            smbd:28845 [ffff8101004ca0c0, 116] (not 
blocked on mutex)
[951862.048297] D            smbd: 2145 [ffff81017de63140, 116] (not 
blocked on mutex)
[951862.048946] S            smbd: 2885 [ffff810113097100, 116] (not 
blocked on mutex)
[951862.049595] S            smbd: 3571 [ffff8100a71800c0, 116] (not 
blocked on mutex)
[951862.050244] S            smbd: 5313 [ffff8100116007a0, 116] (not 
blocked on mutex)
[951862.050891] D            smbd: 5417 [ffff810112e728a0, 116] (not 
blocked on mutex)
[951862.051542] D             mon: 5444 [ffff8101104e10c0, 116] (not 
blocked on mutex)
[951862.052191] D            smbd: 5468 [ffff8101701d40c0, 116] (not 
blocked on mutex)
[951862.052843] S            bash: 6218 [ffff8100d2dc37a0, 115] (not 
blocked on mutex)
[951862.053494] D              cp: 6237 [ffff81012eeb8100, 116] (not 
blocked on mutex)
[951862.054142] S            bash: 6332 [ffff8100d639b7a0, 116] (not 
blocked on mutex)
[951862.054793] D              rm: 6340 [ffff81007d7617a0, 117] 
blocked on mutex: [ffff810081ffe348] {inode_init_once}
[951862.055516] .. held by:                cp: 6237 [ffff81012eeb8100, 116]
[951862.055941] ... acquired at:               0x0
[951862.056299] S            smbd: 6390 [ffff8100f7c8a140, 116] (not 
blocked on mutex)
[951862.056950] D              ls: 6499 [ffff810137d22140, 116] 
blocked on mutex: [ffff8100cbce2d18] {inode_init_once}
[951862.057671] .. held by:                rm: 6340 [ffff81007d7617a0, 117]
[951862.058092] ... acquired at:               0x0
[951862.058444] S            afpd: 6595 [ffff8101086da860, 115] (not 
blocked on mutex)
[951862.059089] D        cnid_dbd: 6947 [ffff810161c15140, 117] (not 
blocked on mutex)
[951862.059739] S            afpd: 7084 [ffff810037ec1820, 115] (not 
blocked on mutex)
[951862.060390] D            smbd: 7136 [ffff8101463db820, 116] (not 
blocked on mutex)
[951862.061039] S            smbd: 7149 [ffff810169e70100, 116] (not 
blocked on mutex)
[951862.061688] D            afpd: 7213 [ffff8100ebe377a0, 115] (not 
blocked on mutex)
[951862.062338] D            smbd: 7754 [ffff8101421f1180, 116] (not 
blocked on mutex)
[951862.062986] D            afpd: 7757 [ffff8100309be7a0, 116] (not 
blocked on mutex)
[951862.063637] D            smbd: 7758 [ffff8101150997e0, 116] (not 
blocked on mutex)
[951862.070404] S            smbd: 7764 [ffff81014b71f080, 116] (not 
blocked on mutex)
[951862.071055] ?            cron: 7771 [ffff810139e10100, 118] (not 
blocked on mutex)
[951862.071706] S            bash: 7772 [ffff810021348180, 116] (not 
blocked on mutex)
[951862.072349] D       run-crons: 7773 [ffff81015c9b7040, 116] (not 
blocked on mutex)
[951862.072991] D            afpd: 7778 [ffff8100bae897e0, 116] (not 
blocked on mutex)
[951862.073637] S            smbd: 8002 [ffff810100eb0860, 116] (not 
blocked on mutex)
[951862.074298] S            smbd: 8088 [ffff810100eb0140, 116] (not 
blocked on mutex)
[951862.074947] D            afpd: 8220 [ffff8100b9b9d860, 116] (not 
blocked on mutex)
[951862.075597] D        cnid_dbd: 8222 [ffff8100b9b9d140, 116] 
blocked on mutex: [ffff8100eba592a8] {journal_init_common}
[951862.076322] .. held by:              afpd: 8220 [ffff8100b9b9d860, 116]
[951862.076745] ... acquired at:               0x0
[951862.077100] D          emerge: 8482 [ffff8101678267e0, 118] (not 
blocked on mutex)
[951862.077750] S            smbd: 9451 [ffff81010022a040, 116] (not 
blocked on mutex)
[951862.078400] D            afpd: 9575 [ffff81002154c8a0, 115] (not 
blocked on mutex)
[951862.079051] S      mail.alert: 9613 [ffff81010c86f040, 119] (not 
blocked on mutex)
[951862.079700] S        sendmail: 9614 [ffff81017dccf180, 119] (not 
blocked on mutex)
[951862.080351] D        postdrop: 9616 [ffff81010d8d58a0, 119] (not 
blocked on mutex)
[951862.081002] S            afpd: 9633 [ffff8100309be080, 115] (not 
blocked on mutex)
[951862.081653] S          pickup: 9697 [ffff8100dee63040, 116] (not 
blocked on mutex)
[951862.082303] D          emerge: 9918 [ffff810139e10820, 120] (not 
blocked on mutex)
[951862.082956] D            sshd: 9924 [ffff81017dff9080, 117] (not 
blocked on mutex)
[951862.083606] S            sshd: 9936 [ffff81015cca7100, 116] (not 
blocked on mutex)
[951862.084254] S            sshd: 9941 [ffff81007d761080, 115] (not 
blocked on mutex)
[951862.084905] S            bash: 9942 [ffff81015fde17e0, 115] (not 
blocked on mutex)
[951862.085555] S            sshd: 9951 [ffff810011600080, 116] (not 
blocked on mutex)
[951862.086205] S            sshd: 9956 [ffff8100dee63760, 115] (not 
blocked on mutex)
[951862.086849] S            bash: 9957 [ffff8101104e17e0, 115] (not 
blocked on mutex)
[951862.087491] S            bash: 9962 [ffff8100cdac9820, 118] (not 
blocked on mutex)
[951862.088139] S    drbd6_worker:10126 [ffff81011a396760, 115] (not 
blocked on mutex)
[951862.088791] S   drbd6_asender:10142 [ffff81006077e7a0, 115] (not 
blocked on mutex)
[951862.089439] S   drbd0_asender:10143 [ffff81007eb63860, 115] (not 
blocked on mutex)
[951862.090090] S   drbd2_asender:10144 [ffff8101086da140, 115] (not 
blocked on mutex)
[951862.090742] S   drbd1_asender:10145 [ffff8100e47b17a0, 115] (not 
blocked on mutex)
[951862.091391] S   drbd3_asender:10146 [ffff8100bae890c0, 115] (not 
blocked on mutex)
[951862.092042] S   drbd7_asender:10147 [ffff8100213488a0, 115] (not 
blocked on mutex)
[951862.092694] R            bash:10189 [ffff8100cdac9100, 115] (not 
blocked on mutex)
[951862.093346]
[951862.093632] ---------------------------
[951862.093931] | showing all locks held: |
[951862.094226] ---------------------------
[951862.094522]
[951862.094523] #001:             [ffff8100ec2eb178] {initialize_tty_struct}
[951862.095176] .. held by:            agetty: 7718 [ffff8100eddda7a0, 116]
[951862.095601] ... acquired at:               read_chan+0x25f/0x6db
[951862.095967]
[951862.095968] #002:             [ffff8100ec2eb990] {initialize_tty_struct}
[951862.096618] .. held by:            agetty: 7719 [ffff8100ee251760, 116]
[951862.097042] ... acquired at:               read_chan+0x25f/0x6db
[951862.097407]
[951862.097408] #003:             [ffff8100ec2a6920] {initialize_tty_struct}
[951862.098059] .. held by:            agetty: 7720 [ffff8100ee2070c0, 116]
[951862.098485] ... acquired at:               read_chan+0x25f/0x6db
[951862.098850]
[951862.098851] #004:             [ffff8100ec75b1f8] {initialize_tty_struct}
[951862.099503] .. held by:            agetty: 7721 [ffff8100ee31d7a0, 116]
[951862.099930] ... acquired at:               read_chan+0x25f/0x6db
[951862.100296]
[951862.100297] #005:             [ffff81017dee9b50] {initialize_tty_struct}
[951862.100941] .. held by:            agetty: 7717 [ffff8100ee251040, 117]
[951862.101364] ... acquired at:               read_chan+0x25f/0x6db
[951862.101725]
[951862.101726] #006:             [ffff8100ec75a9e0] {initialize_tty_struct}
[951862.102374] .. held by:            agetty: 7722 [ffff8100ee220760, 117]
[951862.102800] ... acquired at:               read_chan+0x25f/0x6db
[951862.103164]
[951862.103448] =============================================
[951862.103451]
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
_______________________________________________
drbd-user mailing list
drbd-user@lists.linbit.com
http://lists.linbit.com/mailman/listinfo/drbd-user



