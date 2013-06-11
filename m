Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3FKLLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:11:15 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:37368 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab3FKLLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:11:11 -0400
From: Nix <nix@esperi.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS/lazy-umount/path-lookup-related panics at shutdown (at kill of processes on lazy-umounted filesystems) with 3.9.2 and 3.9.5
References: <871u89vp46.fsf@spindle.srvr.nix>
	<20130611031529.GD4165@ZenIV.linux.org.uk>
Emacs: freely redistributable; void where prohibited by law.
Date: Tue, 11 Jun 2013 12:11:03 +0100
In-Reply-To: <20130611031529.GD4165@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 11 Jun 2013 04:15:29 +0100")
Message-ID: <87k3m0sy0o.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Jun 2013, Al Viro spake thusly:

> On Mon, Jun 10, 2013 at 06:42:49PM +0100, Nix wrote:
>> Yes, my shutdown scripts are panicking the kernel again! They're not
>> causing filesystem corruption this time, but it's still fs-related.
>> 
>> Here's the 3.9.5 panic, seen on an x86-32 NFS client using NFSv3: NFSv4
>> was compiled in but not used. This happened when processes whose
>> current directory was on one of those NFS-mounted filesystems were being
>> killed, after it had been lazy-umounted (so by this point its cwd was in
>> a disconnected mount point).
>
> Hrm...  Could you post (or drop on anonftp, etc.) disassembly of path_init() from
> your kernel?  The code quoted in oops looks very odd...

Sure! The compiler is GCC 4.7.3 20130310 (so not on a release branch: it
is possible this is an already-fixed compiler bug).

Both x86-32 and x86-64 disassemblies follow:

x86:

0000083f <path_init>:
     83f:	55                   	push   %ebp
     840:	57                   	push   %edi
     841:	56                   	push   %esi
     842:	53                   	push   %ebx
     843:	83 ec 0c             	sub    $0xc,%esp
     846:	89 d5                	mov    %edx,%ebp
     848:	89 ca                	mov    %ecx,%edx
     84a:	89 cf                	mov    %ecx,%edi
     84c:	8b 5c 24 20          	mov    0x20(%esp),%ebx
     850:	80 ce 10             	or     $0x10,%dh
     853:	f6 c5 20             	test   $0x20,%ch
     856:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
     85d:	89 53 20             	mov    %edx,0x20(%ebx)
     860:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
     867:	74 6c                	je     8d5 <path_init+0x96>
     869:	8b 43 18             	mov    0x18(%ebx),%eax
     86c:	80 7d 00 00          	cmpb   $0x0,0x0(%ebp)
     870:	8b 70 20             	mov    0x20(%eax),%esi
     873:	74 21                	je     896 <path_init+0x57>
     875:	f6 46 02 02          	testb  $0x2,0x2(%esi)
     879:	0f 85 12 02 00 00    	jne    a91 <path_init+0x252>
     87f:	8b 46 18             	mov    0x18(%esi),%eax
     882:	83 38 00             	cmpl   $0x0,(%eax)
     885:	75 05                	jne    88c <path_init+0x4d>
     887:	e9 9a 01 00 00       	jmp    a26 <path_init+0x1e7>
     88c:	66 83 4e 02 02       	orw    $0x2,0x2(%esi)
     891:	e9 fb 01 00 00       	jmp    a91 <path_init+0x252>
     896:	8b 43 14             	mov    0x14(%ebx),%eax
     899:	8b 53 18             	mov    0x18(%ebx),%edx
     89c:	89 03                	mov    %eax,(%ebx)
     89e:	89 53 04             	mov    %edx,0x4(%ebx)
     8a1:	89 73 1c             	mov    %esi,0x1c(%ebx)
     8a4:	83 e7 40             	and    $0x40,%edi
     8a7:	74 20                	je     8c9 <path_init+0x8a>
     8a9:	b8 00 00 00 00       	mov    $0x0,%eax
     8ae:	e8 fc ff ff ff       	call   8af <path_init+0x70>
     8b3:	8b 53 04             	mov    0x4(%ebx),%edx
     8b6:	8b 42 04             	mov    0x4(%edx),%eax
     8b9:	a8 01                	test   $0x1,%al
     8bb:	74 04                	je     8c1 <path_init+0x82>
     8bd:	f3 90                	pause  
     8bf:	eb f5                	jmp    8b6 <path_init+0x77>
     8c1:	89 43 24             	mov    %eax,0x24(%ebx)
     8c4:	e9 bd 01 00 00       	jmp    a86 <path_init+0x247>
     8c9:	89 d8                	mov    %ebx,%eax
     8cb:	e8 fc ff ff ff       	call   8cc <path_init+0x8d>
     8d0:	e9 b1 01 00 00       	jmp    a86 <path_init+0x247>
     8d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
     8dc:	80 7d 00 2f          	cmpb   $0x2f,0x0(%ebp)
     8e0:	0f 85 8b 00 00 00    	jne    971 <path_init+0x132>
     8e6:	83 e7 40             	and    $0x40,%edi
     8e9:	74 4e                	je     939 <path_init+0xfa>
     8eb:	b8 00 00 00 00       	mov    $0x0,%eax
     8f0:	e8 fc ff ff ff       	call   8f1 <path_init+0xb2>
     8f5:	83 7b 14 00          	cmpl   $0x0,0x14(%ebx)
     8f9:	75 66                	jne    961 <path_init+0x122>
     8fb:	a1 00 00 00 00       	mov    0x0,%eax
     900:	8b 88 54 02 00 00    	mov    0x254(%eax),%ecx
     906:	8b 71 04             	mov    0x4(%ecx),%esi
     909:	f7 c6 01 00 00 00    	test   $0x1,%esi
     90f:	74 04                	je     915 <path_init+0xd6>
     911:	f3 90                	pause  
     913:	eb f1                	jmp    906 <path_init+0xc7>
     915:	8b 51 14             	mov    0x14(%ecx),%edx
     918:	8b 41 10             	mov    0x10(%ecx),%eax
     91b:	89 53 18             	mov    %edx,0x18(%ebx)
     91e:	89 43 14             	mov    %eax,0x14(%ebx)
     921:	8b 53 18             	mov    0x18(%ebx),%edx
     924:	8b 42 04             	mov    0x4(%edx),%eax
     927:	a8 01                	test   $0x1,%al
     929:	74 04                	je     92f <path_init+0xf0>
     92b:	f3 90                	pause  
     92d:	eb f5                	jmp    924 <path_init+0xe5>
     92f:	89 43 24             	mov    %eax,0x24(%ebx)
     932:	39 71 04             	cmp    %esi,0x4(%ecx)
     935:	74 2a                	je     961 <path_init+0x122>
     937:	eb cd                	jmp    906 <path_init+0xc7>
     939:	a1 00 00 00 00       	mov    0x0,%eax
     93e:	8d 6b 14             	lea    0x14(%ebx),%ebp
     941:	8b 80 54 02 00 00    	mov    0x254(%eax),%eax
     947:	8b 70 10             	mov    0x10(%eax),%esi
     94a:	8b 78 14             	mov    0x14(%eax),%edi
     94d:	89 7b 18             	mov    %edi,0x18(%ebx)
     950:	89 73 14             	mov    %esi,0x14(%ebx)
     953:	89 e8                	mov    %ebp,%eax
     955:	e8 fc ff ff ff       	call   956 <path_init+0x117>
     95a:	89 e8                	mov    %ebp,%eax
     95c:	e8 fc ff ff ff       	call   95d <path_init+0x11e>
     961:	8b 43 14             	mov    0x14(%ebx),%eax
     964:	8b 53 18             	mov    0x18(%ebx),%edx
     967:	89 03                	mov    %eax,(%ebx)
     969:	89 53 04             	mov    %edx,0x4(%ebx)
     96c:	e9 0c 01 00 00       	jmp    a7d <path_init+0x23e>
     971:	83 f8 9c             	cmp    $0xffffff9c,%eax
     974:	75 6a                	jne    9e0 <path_init+0x1a1>
     976:	a1 00 00 00 00       	mov    0x0,%eax
     97b:	83 e7 40             	and    $0x40,%edi
     97e:	74 43                	je     9c3 <path_init+0x184>
     980:	8b b0 54 02 00 00    	mov    0x254(%eax),%esi
     986:	b8 00 00 00 00       	mov    $0x0,%eax
     98b:	e8 fc ff ff ff       	call   98c <path_init+0x14d>
     990:	8b 4e 04             	mov    0x4(%esi),%ecx
     993:	f6 c1 01             	test   $0x1,%cl
     996:	74 04                	je     99c <path_init+0x15d>
     998:	f3 90                	pause  
     99a:	eb f4                	jmp    990 <path_init+0x151>
     99c:	8b 56 1c             	mov    0x1c(%esi),%edx
     99f:	8b 46 18             	mov    0x18(%esi),%eax
     9a2:	89 53 04             	mov    %edx,0x4(%ebx)
     9a5:	89 03                	mov    %eax,(%ebx)
     9a7:	8b 53 04             	mov    0x4(%ebx),%edx
     9aa:	8b 42 04             	mov    0x4(%edx),%eax
     9ad:	a8 01                	test   $0x1,%al
     9af:	74 04                	je     9b5 <path_init+0x176>
     9b1:	f3 90                	pause  
     9b3:	eb f5                	jmp    9aa <path_init+0x16b>
     9b5:	89 43 24             	mov    %eax,0x24(%ebx)
     9b8:	39 4e 04             	cmp    %ecx,0x4(%esi)
     9bb:	0f 84 bc 00 00 00    	je     a7d <path_init+0x23e>
     9c1:	eb cd                	jmp    990 <path_init+0x151>
     9c3:	8b 80 54 02 00 00    	mov    0x254(%eax),%eax
     9c9:	8b 50 1c             	mov    0x1c(%eax),%edx
     9cc:	8b 40 18             	mov    0x18(%eax),%eax
     9cf:	89 03                	mov    %eax,(%ebx)
     9d1:	89 53 04             	mov    %edx,0x4(%ebx)
     9d4:	89 d8                	mov    %ebx,%eax
     9d6:	e8 fc ff ff ff       	call   9d7 <path_init+0x198>
     9db:	e9 87 00 00 00       	jmp    a67 <path_init+0x228>
     9e0:	8d 54 24 08          	lea    0x8(%esp),%edx
     9e4:	e8 fc ff ff ff       	call   9e5 <path_init+0x1a6>
     9e9:	8b 54 24 08          	mov    0x8(%esp),%edx
     9ed:	89 c6                	mov    %eax,%esi
     9ef:	89 14 24             	mov    %edx,(%esp)
     9f2:	85 c0                	test   %eax,%eax
     9f4:	0f 84 90 00 00 00    	je     a8a <path_init+0x24b>
     9fa:	8b 40 0c             	mov    0xc(%eax),%eax
     9fd:	80 7d 00 00          	cmpb   $0x0,0x0(%ebp)
     a01:	74 2d                	je     a30 <path_init+0x1f1>
     a03:	8b 40 20             	mov    0x20(%eax),%eax
     a06:	f6 40 02 02          	testb  $0x2,0x2(%eax)
     a0a:	75 24                	jne    a30 <path_init+0x1f1>
     a0c:	8b 48 18             	mov    0x18(%eax),%ecx
     a0f:	83 39 00             	cmpl   $0x0,(%ecx)
     a12:	0f 84 8f 00 00 00    	je     aa7 <path_init+0x268>
     a18:	66 83 48 02 02       	orw    $0x2,0x2(%eax)
     a1d:	eb 11                	jmp    a30 <path_init+0x1f1>
     a1f:	89 f0                	mov    %esi,%eax
     a21:	e8 fc ff ff ff       	call   a22 <path_init+0x1e3>
     a26:	b8 ec ff ff ff       	mov    $0xffffffec,%eax
     a2b:	e9 86 00 00 00       	jmp    ab6 <path_init+0x277>
     a30:	8b 46 08             	mov    0x8(%esi),%eax
     a33:	8b 56 0c             	mov    0xc(%esi),%edx
     a36:	89 53 04             	mov    %edx,0x4(%ebx)
     a39:	89 03                	mov    %eax,(%ebx)
     a3b:	83 e7 40             	and    $0x40,%edi
     a3e:	74 29                	je     a69 <path_init+0x22a>
     a40:	83 3c 24 00          	cmpl   $0x0,(%esp)
     a44:	74 06                	je     a4c <path_init+0x20d>
     a46:	8b 44 24 24          	mov    0x24(%esp),%eax
     a4a:	89 30                	mov    %esi,(%eax)
     a4c:	8b 53 04             	mov    0x4(%ebx),%edx
     a4f:	8b 42 04             	mov    0x4(%edx),%eax
     a52:	a8 01                	test   $0x1,%al
     a54:	74 04                	je     a5a <path_init+0x21b>
     a56:	f3 90                	pause  
     a58:	eb f5                	jmp    a4f <path_init+0x210>
     a5a:	89 43 24             	mov    %eax,0x24(%ebx)
     a5d:	b8 00 00 00 00       	mov    $0x0,%eax
     a62:	e8 fc ff ff ff       	call   a63 <path_init+0x224>
     a67:	eb 14                	jmp    a7d <path_init+0x23e>
     a69:	89 d8                	mov    %ebx,%eax
     a6b:	e8 fc ff ff ff       	call   a6c <path_init+0x22d>
     a70:	83 3c 24 00          	cmpl   $0x0,(%esp)
     a74:	74 07                	je     a7d <path_init+0x23e>
     a76:	89 f0                	mov    %esi,%eax
     a78:	e8 fc ff ff ff       	call   a79 <path_init+0x23a>
     a7d:	8b 43 04             	mov    0x4(%ebx),%eax
     a80:	8b 40 20             	mov    0x20(%eax),%eax
     a83:	89 43 1c             	mov    %eax,0x1c(%ebx)
     a86:	31 c0                	xor    %eax,%eax
     a88:	eb 2c                	jmp    ab6 <path_init+0x277>
     a8a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
     a8f:	eb 25                	jmp    ab6 <path_init+0x277>
     a91:	ba 01 00 00 00       	mov    $0x1,%edx
     a96:	89 f0                	mov    %esi,%eax
     a98:	e8 fc ff ff ff       	call   a99 <path_init+0x25a>
     a9d:	85 c0                	test   %eax,%eax
     a9f:	0f 84 f1 fd ff ff    	je     896 <path_init+0x57>
     aa5:	eb 0f                	jmp    ab6 <path_init+0x277>
     aa7:	83 3c 24 00          	cmpl   $0x0,(%esp)
     aab:	0f 84 75 ff ff ff    	je     a26 <path_init+0x1e7>
     ab1:	e9 69 ff ff ff       	jmp    a1f <path_init+0x1e0>
     ab6:	83 c4 0c             	add    $0xc,%esp
     ab9:	5b                   	pop    %ebx
     aba:	5e                   	pop    %esi
     abb:	5f                   	pop    %edi
     abc:	5d                   	pop    %ebp
     abd:	c3                   	ret    

x86-64:

0000000000002406 <path_init>:
    2406:	e8 00 00 00 00       	callq  240b <get_write_access+0x240b>
    240b:	55                   	push   %rbp
    240c:	89 d0                	mov    %edx,%eax
    240e:	48 89 e5             	mov    %rsp,%rbp
    2411:	41 57                	push   %r15
    2413:	80 cc 10             	or     $0x10,%ah
    2416:	41 56                	push   %r14
    2418:	49 89 f6             	mov    %rsi,%r14
    241b:	41 55                	push   %r13
    241d:	41 89 d5             	mov    %edx,%r13d
    2420:	41 54                	push   %r12
    2422:	53                   	push   %rbx
    2423:	48 89 cb             	mov    %rcx,%rbx
    2426:	48 83 ec 28          	sub    $0x28,%rsp
    242a:	f6 c6 20             	test   $0x20,%dh
    242d:	c7 41 40 01 00 00 00 	movl   $0x1,0x40(%rcx)
    2434:	89 41 38             	mov    %eax,0x38(%rcx)
    2437:	c7 41 44 00 00 00 00 	movl   $0x0,0x44(%rcx)
    243e:	0f 84 9b 00 00 00    	je     24df <get_write_access+0x24df>
    2444:	48 8b 41 28          	mov    0x28(%rcx),%rax
    2448:	80 3e 00             	cmpb   $0x0,(%rsi)
    244b:	4c 8b 60 30          	mov    0x30(%rax),%r12
    244f:	74 40                	je     2491 <get_write_access+0x2491>
    2451:	41 f6 44 24 02 02    	testb  $0x2,0x2(%r12)
    2457:	0f 85 e4 02 00 00    	jne    2741 <get_write_access+0x2741>
    245d:	49 8b 44 24 20       	mov    0x20(%r12),%rax
    2462:	48 83 38 00          	cmpq   $0x0,(%rax)
    2466:	75 05                	jne    246d <get_write_access+0x246d>
    2468:	e9 5a 02 00 00       	jmpq   26c7 <get_write_access+0x26c7>
    246d:	4d 8d b4 24 88 00 00 	lea    0x88(%r12),%r14
    2474:	00 
    2475:	4c 89 f7             	mov    %r14,%rdi
    2478:	e8 00 00 00 00       	callq  247d <get_write_access+0x247d>
    247d:	4c 89 f7             	mov    %r14,%rdi
    2480:	66 41 83 4c 24 02 02 	orw    $0x2,0x2(%r12)
    2487:	e8 00 00 00 00       	callq  248c <get_write_access+0x248c>
    248c:	e9 b0 02 00 00       	jmpq   2741 <get_write_access+0x2741>
    2491:	48 8b 43 20          	mov    0x20(%rbx),%rax
    2495:	41 80 e5 40          	and    $0x40,%r13b
    2499:	4c 89 63 30          	mov    %r12,0x30(%rbx)
    249d:	48 89 03             	mov    %rax,(%rbx)
    24a0:	48 8b 43 28          	mov    0x28(%rbx),%rax
    24a4:	48 89 43 08          	mov    %rax,0x8(%rbx)
    24a8:	74 28                	je     24d2 <get_write_access+0x24d2>
    24aa:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    24b1:	e8 00 00 00 00       	callq  24b6 <get_write_access+0x24b6>
    24b6:	e8 00 00 00 00       	callq  24bb <get_write_access+0x24bb>
    24bb:	48 8b 53 08          	mov    0x8(%rbx),%rdx
    24bf:	8b 42 04             	mov    0x4(%rdx),%eax
    24c2:	a8 01                	test   $0x1,%al
    24c4:	74 04                	je     24ca <get_write_access+0x24ca>
    24c6:	f3 90                	pause  
    24c8:	eb f5                	jmp    24bf <get_write_access+0x24bf>
    24ca:	89 43 3c             	mov    %eax,0x3c(%rbx)
    24cd:	e9 64 02 00 00       	jmpq   2736 <get_write_access+0x2736>
    24d2:	48 89 df             	mov    %rbx,%rdi
    24d5:	e8 00 00 00 00       	callq  24da <get_write_access+0x24da>
    24da:	e9 57 02 00 00       	jmpq   2736 <get_write_access+0x2736>
    24df:	48 c7 41 20 00 00 00 	movq   $0x0,0x20(%rcx)
    24e6:	00 
    24e7:	80 3e 2f             	cmpb   $0x2f,(%rsi)
    24ea:	0f 85 c3 00 00 00    	jne    25b3 <get_write_access+0x25b3>
    24f0:	41 80 e5 40          	and    $0x40,%r13b
    24f4:	74 5e                	je     2554 <get_write_access+0x2554>
    24f6:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    24fd:	e8 00 00 00 00       	callq  2502 <get_write_access+0x2502>
    2502:	e8 00 00 00 00       	callq  2507 <get_write_access+0x2507>
    2507:	48 83 7b 20 00       	cmpq   $0x0,0x20(%rbx)
    250c:	0f 85 8d 00 00 00    	jne    259f <get_write_access+0x259f>
    2512:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    2519:	00 00 
    251b:	48 8b 80 58 05 00 00 	mov    0x558(%rax),%rax
    2522:	8b 50 08             	mov    0x8(%rax),%edx
    2525:	f6 c2 01             	test   $0x1,%dl
    2528:	74 04                	je     252e <get_write_access+0x252e>
    252a:	f3 90                	pause  
    252c:	eb f4                	jmp    2522 <get_write_access+0x2522>
    252e:	48 8b 48 18          	mov    0x18(%rax),%rcx
    2532:	48 89 4b 20          	mov    %rcx,0x20(%rbx)
    2536:	48 8b 70 20          	mov    0x20(%rax),%rsi
    253a:	48 89 73 28          	mov    %rsi,0x28(%rbx)
    253e:	8b 4e 04             	mov    0x4(%rsi),%ecx
    2541:	f6 c1 01             	test   $0x1,%cl
    2544:	74 04                	je     254a <get_write_access+0x254a>
    2546:	f3 90                	pause  
    2548:	eb f4                	jmp    253e <get_write_access+0x253e>
    254a:	89 4b 3c             	mov    %ecx,0x3c(%rbx)
    254d:	39 50 08             	cmp    %edx,0x8(%rax)
    2550:	74 4d                	je     259f <get_write_access+0x259f>
    2552:	eb ce                	jmp    2522 <get_write_access+0x2522>
    2554:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    255b:	00 00 
    255d:	4c 8b a0 58 05 00 00 	mov    0x558(%rax),%r12
    2564:	4c 8d 69 20          	lea    0x20(%rcx),%r13
    2568:	4d 8d 74 24 04       	lea    0x4(%r12),%r14
    256d:	4c 89 f7             	mov    %r14,%rdi
    2570:	e8 00 00 00 00       	callq  2575 <get_write_access+0x2575>
    2575:	49 8b 44 24 18       	mov    0x18(%r12),%rax
    257a:	4c 89 ef             	mov    %r13,%rdi
    257d:	48 89 43 20          	mov    %rax,0x20(%rbx)
    2581:	49 8b 44 24 20       	mov    0x20(%r12),%rax
    2586:	48 89 43 28          	mov    %rax,0x28(%rbx)
    258a:	e8 00 00 00 00       	callq  258f <get_write_access+0x258f>
    258f:	4c 89 f7             	mov    %r14,%rdi
    2592:	e8 00 00 00 00       	callq  2597 <get_write_access+0x2597>
    2597:	4c 89 ef             	mov    %r13,%rdi
    259a:	e8 00 00 00 00       	callq  259f <get_write_access+0x259f>
    259f:	48 8b 43 20          	mov    0x20(%rbx),%rax
    25a3:	48 89 03             	mov    %rax,(%rbx)
    25a6:	48 8b 43 28          	mov    0x28(%rbx),%rax
    25aa:	48 89 43 08          	mov    %rax,0x8(%rbx)
    25ae:	e9 77 01 00 00       	jmpq   272a <get_write_access+0x272a>
    25b3:	83 ff 9c             	cmp    $0xffffff9c,%edi
    25b6:	0f 85 94 00 00 00    	jne    2650 <get_write_access+0x2650>
    25bc:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    25c3:	00 00 
    25c5:	41 80 e5 40          	and    $0x40,%r13b
    25c9:	4c 8b a0 58 05 00 00 	mov    0x558(%rax),%r12
    25d0:	74 4b                	je     261d <get_write_access+0x261d>
    25d2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    25d9:	e8 00 00 00 00       	callq  25de <get_write_access+0x25de>
    25de:	e8 00 00 00 00       	callq  25e3 <get_write_access+0x25e3>
    25e3:	41 8b 44 24 08       	mov    0x8(%r12),%eax
    25e8:	a8 01                	test   $0x1,%al
    25ea:	74 04                	je     25f0 <get_write_access+0x25f0>
    25ec:	f3 90                	pause  
    25ee:	eb f3                	jmp    25e3 <get_write_access+0x25e3>
    25f0:	49 8b 54 24 28       	mov    0x28(%r12),%rdx
    25f5:	48 89 13             	mov    %rdx,(%rbx)
    25f8:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
    25fd:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
    2601:	8b 51 04             	mov    0x4(%rcx),%edx
    2604:	f6 c2 01             	test   $0x1,%dl
    2607:	74 04                	je     260d <get_write_access+0x260d>
    2609:	f3 90                	pause  
    260b:	eb f4                	jmp    2601 <get_write_access+0x2601>
    260d:	89 53 3c             	mov    %edx,0x3c(%rbx)
    2610:	41 39 44 24 08       	cmp    %eax,0x8(%r12)
    2615:	0f 84 0f 01 00 00    	je     272a <get_write_access+0x272a>
    261b:	eb c6                	jmp    25e3 <get_write_access+0x25e3>
    261d:	4d 8d 6c 24 04       	lea    0x4(%r12),%r13
    2622:	4c 89 ef             	mov    %r13,%rdi
    2625:	e8 00 00 00 00       	callq  262a <get_write_access+0x262a>
    262a:	49 8b 44 24 28       	mov    0x28(%r12),%rax
    262f:	48 89 df             	mov    %rbx,%rdi
    2632:	48 89 03             	mov    %rax,(%rbx)
    2635:	49 8b 44 24 30       	mov    0x30(%r12),%rax
    263a:	48 89 43 08          	mov    %rax,0x8(%rbx)
    263e:	e8 00 00 00 00       	callq  2643 <get_write_access+0x2643>
    2643:	4c 89 ef             	mov    %r13,%rdi
    2646:	e8 00 00 00 00       	callq  264b <get_write_access+0x264b>
    264b:	e9 da 00 00 00       	jmpq   272a <get_write_access+0x272a>
    2650:	48 8d 75 cc          	lea    -0x34(%rbp),%rsi
    2654:	4c 89 45 b8          	mov    %r8,-0x48(%rbp)
    2658:	e8 00 00 00 00       	callq  265d <get_write_access+0x265d>
    265d:	44 8b 7d cc          	mov    -0x34(%rbp),%r15d
    2661:	48 85 c0             	test   %rax,%rax
    2664:	49 89 c4             	mov    %rax,%r12
    2667:	4c 8b 45 b8          	mov    -0x48(%rbp),%r8
    266b:	0f 84 c9 00 00 00    	je     273a <get_write_access+0x273a>
    2671:	41 80 3e 00          	cmpb   $0x0,(%r14)
    2675:	48 8b 50 18          	mov    0x18(%rax),%rdx
    2679:	74 56                	je     26d1 <get_write_access+0x26d1>
    267b:	4c 8b 72 30          	mov    0x30(%rdx),%r14
    267f:	41 f6 46 02 02       	testb  $0x2,0x2(%r14)
    2684:	75 4b                	jne    26d1 <get_write_access+0x26d1>
    2686:	49 8b 56 20          	mov    0x20(%r14),%rdx
    268a:	48 83 3a 00          	cmpq   $0x0,(%rdx)
    268e:	0f 84 c4 00 00 00    	je     2758 <get_write_access+0x2758>
    2694:	49 8d 96 88 00 00 00 	lea    0x88(%r14),%rdx
    269b:	48 89 d7             	mov    %rdx,%rdi
    269e:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
    26a2:	e8 00 00 00 00       	callq  26a7 <get_write_access+0x26a7>
    26a7:	66 41 83 4e 02 02    	orw    $0x2,0x2(%r14)
    26ad:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
    26b1:	48 89 d7             	mov    %rdx,%rdi
    26b4:	e8 00 00 00 00       	callq  26b9 <get_write_access+0x26b9>
    26b9:	4c 8b 45 b8          	mov    -0x48(%rbp),%r8
    26bd:	eb 12                	jmp    26d1 <get_write_access+0x26d1>
    26bf:	4c 89 e7             	mov    %r12,%rdi
    26c2:	e8 00 00 00 00       	callq  26c7 <get_write_access+0x26c7>
    26c7:	b8 ec ff ff ff       	mov    $0xffffffec,%eax
    26cc:	e9 95 00 00 00       	jmpq   2766 <get_write_access+0x2766>
    26d1:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
    26d6:	41 80 e5 40          	and    $0x40,%r13b
    26da:	48 89 13             	mov    %rdx,(%rbx)
    26dd:	49 8b 54 24 18       	mov    0x18(%r12),%rdx
    26e2:	48 89 53 08          	mov    %rdx,0x8(%rbx)
    26e6:	74 2d                	je     2715 <get_write_access+0x2715>
    26e8:	45 85 ff             	test   %r15d,%r15d
    26eb:	74 03                	je     26f0 <get_write_access+0x26f0>
    26ed:	4d 89 20             	mov    %r12,(%r8)
    26f0:	48 8b 53 08          	mov    0x8(%rbx),%rdx
    26f4:	8b 42 04             	mov    0x4(%rdx),%eax
    26f7:	a8 01                	test   $0x1,%al
    26f9:	74 04                	je     26ff <get_write_access+0x26ff>
    26fb:	f3 90                	pause  
    26fd:	eb f5                	jmp    26f4 <get_write_access+0x26f4>
    26ff:	89 43 3c             	mov    %eax,0x3c(%rbx)
    2702:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    2709:	e8 00 00 00 00       	callq  270e <get_write_access+0x270e>
    270e:	e8 00 00 00 00       	callq  2713 <get_write_access+0x2713>
    2713:	eb 15                	jmp    272a <get_write_access+0x272a>
    2715:	48 89 df             	mov    %rbx,%rdi
    2718:	e8 00 00 00 00       	callq  271d <get_write_access+0x271d>
    271d:	45 85 ff             	test   %r15d,%r15d
    2720:	74 08                	je     272a <get_write_access+0x272a>
    2722:	4c 89 e7             	mov    %r12,%rdi
    2725:	e8 00 00 00 00       	callq  272a <get_write_access+0x272a>
    272a:	48 8b 43 08          	mov    0x8(%rbx),%rax
    272e:	48 8b 40 30          	mov    0x30(%rax),%rax
    2732:	48 89 43 30          	mov    %rax,0x30(%rbx)
    2736:	31 c0                	xor    %eax,%eax
    2738:	eb 2c                	jmp    2766 <get_write_access+0x2766>
    273a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
    273f:	eb 25                	jmp    2766 <get_write_access+0x2766>
    2741:	be 01 00 00 00       	mov    $0x1,%esi
    2746:	4c 89 e7             	mov    %r12,%rdi
    2749:	e8 00 00 00 00       	callq  274e <get_write_access+0x274e>
    274e:	85 c0                	test   %eax,%eax
    2750:	0f 84 3b fd ff ff    	je     2491 <get_write_access+0x2491>
    2756:	eb 0e                	jmp    2766 <get_write_access+0x2766>
    2758:	45 85 ff             	test   %r15d,%r15d
    275b:	0f 84 66 ff ff ff    	je     26c7 <get_write_access+0x26c7>
    2761:	e9 59 ff ff ff       	jmpq   26bf <get_write_access+0x26bf>
    2766:	48 83 c4 28          	add    $0x28,%rsp
    276a:	5b                   	pop    %rbx
    276b:	41 5c                	pop    %r12
    276d:	41 5d                	pop    %r13
    276f:	41 5e                	pop    %r14
    2771:	41 5f                	pop    %r15
    2773:	5d                   	pop    %rbp
    2774:	c3                   	retq   
